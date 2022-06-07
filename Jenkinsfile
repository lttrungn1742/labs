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
        stage('Test'){
            steps {
                get_approval_from_user("${params.GET_APPROVAL}")
            }
        }
    }
}
