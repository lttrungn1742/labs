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
                sh 'ls -al /tmp/'
                sh 'cd zap && ./full_scan.sh'
                
            }
        }
    }
}
