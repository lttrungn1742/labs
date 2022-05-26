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
                ls -akh
               // sh 'cd zap && ./full_scan.sh'
            }
        }

        stage('Clean Up Container'){
            steps{
                sh './web_demo/stop.sh'
                sh 'cat zap/report.json'
            }
        }
    }
}
