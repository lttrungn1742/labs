pipeline {
    agent any
    stages {
        stage('Build and Deploy'){
            steps {
                sh 'cd web && docker-compose up -d'
            }
        }
        stage('Zap') {
            steps {
                sh 'docker run -v /tmp:/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t http://172.30.200.10:65223 -J report_zap.json'
                sh 'cd web && docker-compose down'
            }
        }
        stage("Slack notification"){
            steps {
                sh 'python3 ./zap/slack_notify.py /tmp/report_zap.json'
            }
        }
    }
}
