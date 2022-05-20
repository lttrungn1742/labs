pipeline {
    agent any
    stages {
        stage('Test') {
                docker {
                    image 'owasp/zap2docker-stable'
                    args '-v $(pwd):/zap/wrk/:rw  -t https://acbc1f171e476eafc061185600840014.web-security-academy.net/product?productId=12 -g gen.conf -J testreport.json --hook=/zap/wrk/my-hooks.py'
                }
            }
            steps {
                sh 'ls -alh'
            }
        }
    }
}

/*
docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py \
    -t https://acbc1f171e476eafc061185600840014.web-security-academy.net/product?productId=12 -g gen.conf -J testreport.json --hook=/zap/wrk/my-hooks.py
*/