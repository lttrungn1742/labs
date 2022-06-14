import groovy.json.JsonSlurper

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
	def jsonSlurper = new JsonSlurper()


	def blocks = "[{'type': 'header', 'text': {'type': 'plain_text', 'text': 'Alert Processing Completed', 'emoji': True}}]"

				
	def objBlocks = new JsonSlurper().parseText( blocks )


	slackSend color : "danger", blocks: "${buildSummary}", channel: '#devops-testing'
		
}