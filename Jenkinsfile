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
                sh './zap/full_scan.sh"'
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
