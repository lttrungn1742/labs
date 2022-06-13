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
	if ( currentBuild.currentResult == "SUCCESS" ) {
		buildSummary = "Job:  ${env.JOB_NAME}\n Status: *SUCCESS*\n Build Report: ${env.BUILD_URL}CI-Build-HTML-Report"

		slackSend color : "good", message: "${buildSummary}", channel: '#devops-testing'
		}
	else {
		buildSummary = "Job:  ${env.JOB_NAME}\n Status: *FAILURE*\n Error description: *${CI_ERROR}* \nBuild Report :${env.BUILD_URL}CI-Build-HTML-Report"
		slackSend color : "danger", message: "${buildSummary}", channel: '#devops-testing'
		}
}