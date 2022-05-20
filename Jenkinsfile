pipeline {
    agent none
    stages {
        stage('Test') {
            agent{
                docker {
                    image 'owasp/zap2docker-stable'
                    args '-v scripts/zap/wrk:/zap/wrk/:rw'
                }
            }
            steps {
                sh 'ls -alh zap'
            }
        }
    }
}
