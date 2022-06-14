
SLACK_CHANNEL = "#devops-testing"
SLACK_TOKEN = 'xoxb-226197665236-1878462028564-YeLRvFunpypwEdBGho8icK9E'
LOG_LEVEL = 'DEBUG'

# from slack import WebClient
# from slack.errors import SlackApiError
# import logging, sys

# import requests
import sys

print(sys.argv[1])



# client = WebClient(token=SLACK_TOKEN)
# logger = logging.getLogger(__name__)
# logger.setLevel(LOG_LEVEL)

# JOB_NAME = sys.argv[1]
# BUILD_URL = sys.argv[2]
# BRANCH_NAME = sys.argv[3]
# BUILD_ID = sys.argv[4]
# BUILD_NUMBER = sys.argv[5]

# def build_message():
#     slack_message = {
#             "blocks": [
#                 {
#                     'type': 'header',
#                     "text": {
#                         "type": "plain_text",
#                         "text": JOB_NAME,
#                         "emoji": True
#                     }
#                 },
#                 {
#                     "type": "section",
#                     "text": {
#                         "type": "mrkdwn",
#                         "text": "*<{}>*".format(BUILD_URL)
#                     }
#                 },
#                 {
#                     "type": "section",
#                     "fields": [
#                         {
#                             "type": "mrkdwn",
#                             "text": "*BuildId:* {}".format(BUILD_ID)
#                         },
#                         {
#                             "type": "mrkdwn",
#                             "text": "*Branch:* {}".format(BRANCH_NAME)
#                         },
#                         {
#                             "type": "mrkdwn",
#                             "text": "*Build Number:* {}".format(BUILD_NUMBER)
#                         }
#                     ]
#                 },
#                 {
#                     "type": "divider"
#                 },
#                 {
#                     "type": "section",
#                     "fields": [
#                         {
#                             "type": "mrkdwn",
#                             "text": "*Now Status:* {}".format(message_json['now_status'])
#                         },
#                         {
#                             "type": "mrkdwn",
#                             "text": "*What Happened:* {}".format(message_json['what_happended'])
#                         }, {
#                             "type": "mrkdwn",
#                             "text": "*Reason:* {}".format(message_json['reason'])
#                         }, {
#                             "type": "mrkdwn",
#                             "text": "*Next Action:* {}".format(message_json['next_action'])
#                         }
#                     ]
#                 },
#             ]
#     }
    
#     return slack_message


# try:    
#     message_to_send = build_message()
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

    
