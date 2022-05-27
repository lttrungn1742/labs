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
                sh 'cat /tmp/rp.md'
                sh 'cd zap && ./full_scan.sh'
                
            }
        }
    }
}
