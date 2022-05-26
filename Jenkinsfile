pipeline {
    agent any
    stages {
        stage('Build and Deploy'){
            steps{
                sh './web_demo/build_run.sh'
                sh 'cd zap && ./full_scan.sh'
                sh 'ls -alh zap/'
            }
        }
        // stage('Zap') {
        //     steps {
                
        //     }
        // }

        // stage('Done'){
        //     steps{
        //         sh './web_demo/stop.sh'
                
        //         sh 'cat zap/report.json'
        //     }
        // }
    }
}
