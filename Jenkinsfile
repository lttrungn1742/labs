pipeline {
    agent any
    stages {
        stage('Build and Deploy'){
            steps {
                sh 'docker-compose --file web/docker-compose.yml build && docker-compose --file web/docker-compose.yml up web nginx'
            }
        }
        stage('Scan') {
            steps {
                sh 'docker-compose --file web/docker-compose.yml up scaner ; docker-compose --file web/docker-compose.yml down'
            }
        }
        stage("Slack notification"){
            steps {
                sh 'python3 ./zap/slack_notify.py /tmp/report.json'
            }
        }
    }
}
