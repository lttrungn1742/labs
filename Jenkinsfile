pipeline {
    agent any
    stages {
        stage('Build and Deploy'){
            steps{
                sh './web_demo/build_run.sh'
            }
        }
        stage('Zap') {
            steps {
                sh 'cd scripts && ./full_scan.sh'
            }
        }

        stage('Done'){
            steps{
                sh './web_demo/stop.sh'
            }
        }
    }
}
