
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
				// CONSOLE_LOG = "${env.BUILD_URL}/console"
				// BUILD_STATUS = currentBuild.currentResult
	
				// sh 'echo slack'
				// sendSlackNotifcation("${env.BUILD_URL}", "${env.EXECUTOR_NUMBER}")
				def job_exec_details = build job: 'build_job', propagate: false, wait: true // Here wait: true means current running job will wait for build_job to finish.
                    
                if (job_exec_details.getResult() == 'FAILURE') {
                    echo "JOB FAILED"
                }
			}
		}
	}
}

def sendSlackNotifcation(String BUILD_URL, String CI) 
{ 	
	sh 'echo ${EXECUTOR_NUMBER}'
	slackSend(channel: "#devops-testing", message: "Build failed. Broadcast to channel for better visibility.")
}