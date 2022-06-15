
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
				sh 'exit 1'
			}
		}
	}
	
	post {
		
		success {
			script {
				 CONSOLE_LOG = "${env.BUILD_URL}/console"
				 BUILD_STATUS = currentBuild.currentResult
				sh 'echo ${CONSOLE_LOG}'
				sh 'echo ${BUILD_STATUS}'
			}
		}

		failure {
			script {
				CONSOLE_LOG = "${env.BUILD_URL}/console"
				BUILD_STATUS = currentBuild.currentResult
				sh 'echo ${CONSOLE_LOG}'
				sh 'echo ${BUILD_STATUS}'
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