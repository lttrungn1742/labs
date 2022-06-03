pipeline {
    agent any
    stages {
        stage('Build'){
            steps {
                sh 'docker-compose --file web/docker-compose.yml build'
            }
        }
        stage('Deploy'){
            steps {
                sh 'docker-compose --file web/docker-compose.yml up -d web nginx'
            }
        }
        stage('Scan') {
            steps {
                sh 'docker-compose --file web/docker-compose.yml up scaner '
                sh 'docker-compose --file web/docker-compose.yml down'
            }
        }
        stage("Slack notification"){
            steps {
                sh 'python3 ./zap/slack_notify.py /tmp/report.json'
            }
        }
    }
}
