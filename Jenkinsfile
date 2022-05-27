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
                sh 'cd zap && ./full_scan.sh && ls -alh'
            }
        }

        stage('Clean Up Container'){
            steps{
                //sh './web_demo/stop.sh'
                sh 'ls -alh /tmp/'
            }
        }
    }
}
