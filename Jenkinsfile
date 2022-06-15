
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
				sh "SUCCESS"
			}
		}

		failure {
			script {
				def CONSOLE_LOG = "${env.BUILD_URL}/console"
				sh "FAILD"
			}
		}
	}
}

def sendSlackNotifcation(CHANNEL, CONSOLE_LOG, JOB_NAME, isSuccess = true) 
{ 	
	// def attachments = [
	// 	[
	// 		text: 'I find your lack of faith disturbing!',
	// 		fallback: 'Hey, Vader seems to be mad at you.',
	// 		color: '#ff0000'
	// 	]
	// ]
	slackSend(channel: "${CHANNEL}", message: "Build failed. Console log: ${CONSOLE_LOG}")
}