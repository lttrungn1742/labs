pipeline {
    agent {
        docker {
            image 'owasp/zap2docker-stable'
            args '-v $(pwd):/zap/wrk/:rw  -t https://acbc1f171e476eafc061185600840014.web-security-academy.net/product?productId=12 -g gen.conf -J testreport.json --hook=/zap/wrk/my-hooks.py'
        }
    }
    stages {
        stage('Test') {
            steps {
                sh 'ls -alh'
            }
        }
    }
}
