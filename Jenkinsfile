pipeline {
    agent none
    stages {
        stage('Test') {
            agent{
                docker {
                        image 'owasp/zap2docker-stable'
                }
            }
            steps {
                sh 'ls -alh'
            }
        }
    }
}
