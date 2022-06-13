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
            echo 'I failed :( ${env.BUILD_URL}'
        }
    }
}
