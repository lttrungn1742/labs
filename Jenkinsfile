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
				def restResponse = '[{"uid":10512213, "name":"Bob"},{"uid":7208201, "name":"John"},{"uid":10570, "name":"Jim"},{"uid":1799657, "name":"Sally"}]'

				// Parse the response
				def list = new JsonSlurper().parseText( restResponse )

				// Print them out to make sure
				list.each { println it }
		
			//	sendSlackNotifcation()
			}
		}
	}
}

// def sendSlackNotifcation() 
// { 
// 	def jsonSlurper = new JsonSlurper()
// 	def object = jsonSlurper.parseText('{ "name": "John Doe" } /* some comment */')

// 	buildSummary = [
// 				{
//                     "type": "header",
//                     "text": {
//                         "type": "plain_text",
//                         "text": "Alert Processing Completed",
//                         "emoji": True
//                     }
//         		}
// 			]
// 	slackSend color : "danger", blocks: "${buildSummary}", channel: '#devops-testing'
		
// }