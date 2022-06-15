@Library('vietlink-jenkins-pipeline-library-dev') _


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
				sendSlackNotifcation("SUCCESSFUL")
			}
		}

		failure {
			script {
				def attachments = [
					[
						text: 'I find your lack of faith disturbing!',
						fallback: 'Hey, Vader seems to be mad at you.',
						color: '#ff0000'
					]
				]

				slackSend(channel: "#general", attachments: attachments)
			}
		}
	}
}

