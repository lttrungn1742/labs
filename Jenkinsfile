pipeline {
    agent any
    stages {
        stage('Build and Deploy'){
            steps {
                sh './web_demo/build_run.sh'
            }
        }
        stage('Zap') {
            steps {
                sh './zap/full_scan.sh || echo "Done Scan"'
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
