pipeline {
	agent any
	stages {
		stage ('SCM Checkout') {
			steps {
				script {
					CI_ERROR = "Failed while checking out SCM"
          
				}
			}
		}
		stage ('Build Application') {
			steps {
				script {
					CI_ERROR = "Failed while building application"
          			
				}
			}
		}
		stage ('Deploy Application') {
			steps {
				script {
					CI_ERROR = "Failed while deploying application"
          			
				}
			}
		}
	}
	
	post {
		always {
			script {
				CONSOLE_LOG = "${env.BUILD_URL}/console"
				BUILD_STATUS = currentBuild.currentResult
				if (currentBuild.currentResult == 'SUCCESS') {
					CI_ERROR = "NA"
					}
				}
			
		
				sendSlackNotifcation()
		}
	}
}

def sendSlackNotifcation() 
{ 
	slackSend color : "danger", blocks: "{'type':'header', 'text': {'type': 'plain_text','text':'Alert Processing Completed','emoji': true}}", channel: '#devops-testing'	
}