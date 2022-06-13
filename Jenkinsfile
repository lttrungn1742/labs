@Library('vietlink-jenkins-pipeline-library-dev') _

pipeline {
    agent any
    parameters {
        choice(name: "NODE_LABEL", choices: ["vietlink-jenkins-1"])
        string(name: 'PROJECT_NAME', defaultValue: 'vietlink-wordpress', description: 'Enter service name?')
        choice(name: 'ENVIRONMENT', choices: ['dev'], description: 'Enter short environment name?')
        choice(name: 'GET_APPROVAL', choices: ['No', 'Yes'], description: 'Do you want to confirm before going to the next or not?')
    }
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
            echo "Fail"
        }
    }
}
