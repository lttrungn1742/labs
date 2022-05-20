pipeline {
    agent none
    stages {
        stage('Test') {
            agent{
                docker {
                    image 'owasp/zap2docker-stable'
                    args '-v $(pwd):/zap/wrk/:rw'
                }
            }
            steps {
                sh 'docker -v'
            }
        }
    }
}
