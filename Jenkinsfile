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