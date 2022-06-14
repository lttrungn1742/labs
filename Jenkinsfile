import net.sf.json.JSONException

pipeline {
	agent any
	stages {
		stage ('SCM Checkout') {
			steps {
				sh 'echo scm'
			}
		}
		stage ('Build Application') {
			steps {
				sh 'echo build'
			}
		}
		stage ('Deploy Application') {
			steps {
				sh 'echo deploy'
			}
		}
	}
	
	post {
		always {
			script {
				CONSOLE_LOG = "${env.BUILD_URL}/console"
				BUILD_STATUS = currentBuild.currentResult
	
				sh 'echo slack'
				sendSlackNotifcation()
			}
		}
	}
}

def sendSlackNotifcation() 
{ 
	blocks = [
	[
		"type": "section",
		"text": [
			"type": "mrkdwn",
			"text": "Hello, Assistant to the Regional Manager Dwight! *Michael Scott* wants to know where you'd like to take the Paper Company investors to dinner tonight.\n\n *Please select a restaurant:*"
		]
	],
    [
		"type": "divider"
	],
	[
		"type": "section",
		"text": [
			"type": "mrkdwn",
			"text": "*Farmhouse Thai Cuisine*\n:star::star::star::star: 1528 reviews\n They do have some vegan options, like the roti and curry, plus they have a ton of salad stuff and noodles can be ordered without meat!! They have something for everyone here"
		],
		"accessory": [
			"type": "image",
			"image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/c7ed05m9lC2EmA3Aruue7A/o.jpg",
			"alt_text": "alt text for image"
		]
	]
]
   	slackSend (channel: "#devops-testing", color: "danger",  blocks: blocks)
		
}