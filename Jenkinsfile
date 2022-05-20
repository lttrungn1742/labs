pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh './scripts/full_scan.sh'
            }
        }
    }
}

// node {
//     stage("Test"){
//         sh 'docker -v'
//     }

// }