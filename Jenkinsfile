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
                sh 'docker run -v /tmp:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-full-scan.py -t http://localhost:65223 -J report_zap.json'
            }
        }
        stage("Slack notification"){
            steps {
                sh 'python3 ./zap/slack_notify.py /tmp/report_zap.json'
                sh 'cd web && docker-compose down'
            }
        }
    }
}
