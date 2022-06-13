@Library('vietlink-jenkins-pipeline-library-dev') _

pipeline {
    agent any

    stages {
        stage('Build'){
            steps {
               sh 'echo pass'
            }
        }
        stage('Deploy'){
            steps{
                sh 'exit 1'
            }
        }
    }
    post {
        always {
            script {
                    def job = jenkins.model.Jenkins.instance.getItemByFullName("Job name")
                    def result = job.getLastBuild().getResult().toString()
               
                }
            sh 'echo Slack Notify ${env.JOB_NAME}'
        }
    }
}
