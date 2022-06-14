
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
				sendSlackNotifcation("${env.BUILD_URL}")
			}
		}
	}
}

def sendSlackNotifcation(String BUILD_URL) 
{ 
	sh 'ls -al'
	sh 'curl ${BUILD_URL}/api/json'
}