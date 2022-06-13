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
            sh 'echo Slack Notify ${env.JOB_NAME}'
        }
    }
}
