# std lib
import datetime
import json
import os
import logging
import boto3

# 3rd lib
from slack import WebClient

# declare
SLACK_ICON_EMOJI = ":terraform:"

# boto3.setup_default_session(profile_name='gict-dev')

SLACK_ICON_EMOJI = os.getenv("SLACK_ICON_EMOJI", ":aws:")
SLACK_CHANNEL = os.getenv("SLACK_CHANNEL", "C01FEN2UV0F")
SLACK_MENTIONS_USER_STR = os.getenv("SLACK_MENTIONS_ID", "")
ENV = os.getenv("ENV", "dev")
PROJECT = os.getenv("PROJECT", "")
# logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
logger.setLevel(level=logging.INFO)

# Const
SUCCESS_WITH_NOCHANGE = '0'
FAILED = '1'
SUCCESS_WITH_CHANGES = '2'
# Checkov Const
CHECKOV_FAILED = '0'
CHECKOV_PASSED = '1'
TFSEC_PASSED = '0'
TFLINT_PASSED = '0'

def get_slack_token(parameter_name):
    client = boto3.client('ssm',  region_name='ap-northeast-1')

    response = client.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    return response['Parameter']['Value']

def format_slack_message(change_list, failed_list):
    message_color = "warning"
    mention_user = True

    subject = "Terraform changes were detected"
    if mention_user:
        subject = f"{subject}\n{SLACK_MENTIONS_USER_STR}"
    slack_message = {
        "text": subject,
        "attachments": [
            {
                "fallback": "Terraform changes were detected",
                "color": message_color,
                "title": "Terraform changes were detected",
                # "title_link": image_url,
                "text": "The following terraforms were changed: \r\n{}\r\nThe following terraforms were failed: \r\n{}".
                format("\n".join(change_list), "\n".join(failed_list)),
                # "fields": slack_message_fields,
                "footer": "Terraform changes detector",
                'footer_icon': SLACK_ICON_EMOJI,
                "ts": f"{datetime.datetime.now().timestamp()}"
            }
        ]
    }
    return slack_message


def send_to_slack(messages, SLACK_TOKEN):
    logger.info(f"send notify to slack channel {SLACK_CHANNEL}")
    username = f"Terraform changes detector"
    messages.update(
        {
            "username": username.strip(),
            "icon_emoji": SLACK_ICON_EMOJI,
            "channel": SLACK_CHANNEL,
        }
    )
    slack = WebClient(token=SLACK_TOKEN)
    response = slack.chat_postMessage(
        **messages
    )

    return response['ts']

def keys(bucket_name, prefix='/', delimiter='/'):
    prefix = prefix[1:] if prefix.startswith(delimiter) else prefix
    bucket = boto3.resource('s3').Bucket(bucket_name)
    return (_.key for _ in bucket.objects.filter(Prefix=prefix))


def changes_detector(s3_bucket, s3_object_list):
    change_list = []
    failed_list = []
    for s3_object_name in s3_object_list:
        logger.info(s3_object_name)
        client = boto3.client('s3')
        response = client.head_object(
            Bucket=s3_bucket,
            Key=s3_object_name,
        )
        metadata = response["Metadata"]
        logger.debug("Metatdata={}".format(metadata))
        if metadata.get("changed"):
            if metadata.get("changed") == SUCCESS_WITH_CHANGES:
                change_list.append(s3_object_name)
        elif metadata.get("checkov_failed"):
            if metadata.get("checkov_failed") == CHECKOV_FAILED:
                failed_list.append(s3_object_name)
        elif metadata.get("tfsec_passed"):
            if metadata.get("tfsec_passed") != TFSEC_PASSED:
                failed_list.append(s3_object_name)
        elif metadata.get("tflint_passed"):
            if metadata.get("tflint_passed") != TFSEC_PASSED:
                failed_list.append(s3_object_name)
        else:
            logger.error("Metadata key not found")
            raise KeyError
    logger.debug(failed_list)
    return change_list, failed_list

def parse_component(change_list : list):
    lengthX, lengthY = len('terraform-plan-output/'), len('.out') 
    """
    get component in 'terraform-plan-output/common.out'
    """
    component_list = [line[lengthX:-lengthY] for line in change_list]

    return component_list

def lambda_handler(event, _context):
    SLACK_TOKEN =  get_slack_token(f'/{ENV}/SLACK_TOKEN')
    logger.info("event: {}".format(json.dumps(event)))
    s3_bucket_name = "terraform-{}-{}".format(PROJECT, ENV)
    s3_object_list = keys(s3_bucket_name, "terraform-plan-output")
    logger.warn(s3_object_list)
    change_list, failed_list = changes_detector(s3_bucket_name, s3_object_list)
    
    if change_list or failed_list:
        slack_message = format_slack_message(change_list, failed_list)
        THREAD_TS = send_to_slack(slack_message, SLACK_TOKEN)
        logger.info("Changed")
    else:
        slack_message = {
            "text": f"Project {PROJECT} on {ENV} environment has no changes detected",
        }
        THREAD_TS = send_to_slack(slack_message,SLACK_TOKEN)
        logger.info("No changes detected")
    
    return {
        'statusCode': 200,
        'body': json.dumps('change_list = {} \r\nLambda invocation completed!'.format(change_list)),
        'components': parse_component(change_list) if change_list else [],
        'thread_ts': THREAD_TS
    }