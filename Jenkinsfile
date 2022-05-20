pipeline {
    agent {
        docker { image 'owasp/zap2docker-stable' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'ls -alh'
            }
        }
    }
}