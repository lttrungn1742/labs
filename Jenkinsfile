pipeline {
    agent any
    stages {
        stage('Build'){
            steps {
                sh './pre_build.sh'
            }
        }
        stage('Deploy'){
            steps {
                sh './build.sh'
            }
        }
        stage('Scan') {
            steps {
                sh './scan.sh'
            }
        }
        stage("Notification"){
            steps {
                sh 'python3 slack_notify.py /tmp/report.json'
            }
        }
    }
}
