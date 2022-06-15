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
		always {
			script {
				sendSlackNotifcation("${currentBuild.result}","#devops-testing",["U03CQNFKN75"])
			}
		}
	}
}

