pipeline {
    agent any
    stages {
        stage('Build'){
            steps {
                sh './script/build.sh'
            }
        }
        stage('Deploy'){
            steps {
                sh './script/deploy.sh'
            }
        }
        stage('Scan') {
            steps {
                sh './script/scan.sh'
                sh './script/remove.sh'
            }
        }
        stage("Notification"){
            steps {
                sh 'python3 script/slack_notify.py /tmp/report.json'
            }
        }
    }
}
