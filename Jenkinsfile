
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
				sh 'exit 0'
			}
		}
	}
	
	post {
		
		success {
			script {
				def CONSOLE_LOG = "${env.BUILD_URL}/console"
				sendSlackNotifcation("#devops-testing",CONSOLE_LOG, "${env.JOB_NAME}")
			}
		}

		failure {
			script {
				def CONSOLE_LOG = "${env.BUILD_URL}/console"
				sendSlackNotifcation("#devops-testing",CONSOLE_LOG, "${env.JOB_NAME}", false)
			}
		}
	}
}

def sendSlackNotifcation(CHANNEL, CONSOLE_LOG, JOB_NAME, isSuccess = true) 
{ 	
	String message = "*Job Name:* ${JOB_NAME}\n"
	if (isSuccess){
		color = "good"
		message += "*Build Success* \n *Console log:* ${CONSOLE_LOG}"
	}
	else {
		color = "danger"
		message += "*Build Fail* \n *Console log:* ${CONSOLE_LOG}"
	}
	

	slackSend(color: color, channel: CHANNEL, message: message)
}