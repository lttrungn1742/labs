
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
		"blocks": [
			"type": "section",
			"text": [
				"type": "mrkdwn",
				"text": "A message *with some bold text* and _some italicized text_."
			]
		]
	]

slackSend(channel: "#devops-testing", blocks: blocks)
		
}