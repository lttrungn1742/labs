pipeline {
    agent any
    stages {
        stage('Build'){
            steps {
                sh './script/pre_build.sh'
            }
        }
        stage('Deploy'){
            steps {
                sh './script/build.sh'
            }
        }
        stage('Scan') {
            steps {
                sh './script/scan.sh'
            }
        }
        stage("Notification"){
            steps {
                sh 'python3 slack_notify.py /tmp/report.json'
            }
        }
    }
}
