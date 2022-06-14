import os
VERSION = '0.0.1'
ENV = os.getenv("ENV", "local")
SLACK_CHANNEL = os.getenv('SLACK_CHANNEL', 'C02C6S5KASZ')
SLACK_MENTIONS_ID = os.getenv('SLACK_MENTIONS_ID', 'U01CF44P108')
SLACK_TOKEN = os.getenv('SLACK_TOKEN', 'xoxb-226197665236-1878462028564-YeLRvFunpypwEdBGho8icK9E')

LOG_LEVEL = os.getenv('LOG_LEVEL', 'DEBUG')

from slack import WebClient
from slack.errors import SlackApiError
import logging

client = WebClient(token=SLACK_TOKEN)
logger = logging.getLogger(__name__)
logger.setLevel(LOG_LEVEL)

message_json = {
    'alert_info': {
        'alert_id': '1212',
        'alert_name': 'jenkins',
        'alert_info': 'success',
        'alert_time': 'qsasas'
    },
    'now_status': 'true',
    'what_happended': 'no happend',
    'reason': 'no',
    'next_action' : 'assas'
    
}

def build_message(message_json):
    slack_message = {
            "blocks": [
                {
                    "type": "header",
                    "text": {
                        "type": "plain_text",
                        "text": "Alert Processing Completed",
                        "emoji": True
                    }
                },
                # {
                #     "type": "section",
                #     "text": {
                #         "type": "mrkdwn",
                #         "text": "*<google.com|{}>*".format("asasas")
                #     }
                # },
                # {
                #     "type": "section",
                #     "fields": [
                #         {
                #             "type": "mrkdwn",
                #             "text": "*AlertId:* {}".format(message_json['alert_info']['alert_id'])
                #         },
                #         {
                #             "type": "mrkdwn",
                #             "text": "*AlertName:* {}".format(message_json['alert_info']['alert_name'])
                #         },
                #         {
                #             "type": "mrkdwn",
                #             "text": "*Alert Time:* {}".format(message_json['alert_info']['alert_time'])
                #         }
                #     ]
                # },
                # {
                #     "type": "divider"
                # },
                # {
                #     "type": "section",
                #     "fields": [
                #         {
                #             "type": "mrkdwn",
                #             "text": "*Now Status:* {}".format(message_json['now_status'])
                #         },
                #         {
                #             "type": "mrkdwn",
                #             "text": "*What Happened:* {}".format(message_json['what_happended'])
                #         }, {
                #             "type": "mrkdwn",
                #             "text": "*Reason:* {}".format(message_json['reason'])
                #         }, {
                #             "type": "mrkdwn",
                #             "text": "*Next Action:* {}".format(message_json['next_action'])
                #         }
                #     ]
                # },
            ]
    }
    
    print(slack_message)
    return slack_message


build_message(message_json)

# try:    
#     message_to_send = build_message(message_json)
#     message_to_send.update({
#                 "username": "Jenkins testing",
#                 "icon_emoji": ":cooldoge:",
#                 "channel": '#devops-testing',      
#     })
#     response = client.chat_postMessage(
#         **message_to_send
#     )

# except SlackApiError as e:
#     assert e.response["ok"] is False
#     assert e.response["error"] 
#     logger.debug(f"Got an error: {e.response['error']}")

    
