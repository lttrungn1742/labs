import json, requests

web_hook = "https://hooks.slack.com/services/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"

try:
	report = json.loads(open('/tmp/rp.json','r').read())
except:
    exit("No such report")

message = [
		{
			"type": "header",
			"text": {
				"type": "plain_text",
				"text": report['@generated']
			}
		}
]

for site in report['site']:
    if site['alerts'] == []:
        continue
    for alerts in site['alerts']:
        fields =  [
				{
					"type": "mrkdwn",
					"text": f"*name:*\n{alerts['name']}"
				},
				{
					"type": "mrkdwn",
					"text": f"*riskdesc:*\n{alerts['riskdesc']}"
				}
		]
        
        payload_attack = '\n'.join([instance['attack'] for instance in alerts['instances']]) 
        if payload_attack != '\n' or payload_attack != '':
            fields.append(
                {
					"type": "mrkdwn",
					"text": "*payload attack:*\n" + payload_attack
				})
        
        p = {
			"type": "section",
			"fields": fields
		}
        
        message.append(p)
        
payload = {
    'as_user': False,
    'username': 'ZAP - Testing',
    'icon_emoji': ':chart_with_upwards_trend:',
	"channel": "#devops-testing",
	"text": "Zap - pipeline",
	"blocks": message 
}

s = requests.session()


response = s.post(
    web_hook,
    headers={'Content-Type': 'application/json'},
    data=json.dumps(payload),
)

print("Slack notification success" if response.status_code == 200 else f"Fail, due to{response.content}")



