pipeline {
    agent none
    stages {
        stage('Test') {
            agent{
                docker {
                    image 'owasp/zap2docker-stable'
                    args '-p 8090:8090 -daemon -port 8090 -host 0.0.0.0'
                }
            }
            steps {
                sh 'ls -alh'
            }
        }
    }
}

// node {
//     stage("Test"){
//         sh 'docker -v'
//     }

// }