@Library('vietlink-jenkins-pipeline-library-dev') _

pipeline {
    agent {label 'vietlink-jenkins-1'}
    options {
        ansiColor('xterm')
    }
    parameters {
        choice(name: 'SCRIPT_NAME', choices: ['build.sh','slack_notify.sh','augame.sh'], description: 'Module name')
        string(name: 'SCRIPT_PATH', defaultValue: "scripts", description: 'Terraform module location')
        choice(name: 'BRANCH', choices: ["origin/feature/cicd_scripts", "origin/master", "origin/feature/v0.0.3-augame"], description: 'BRANCH name')
        gitParameter  name: 'LATEST_TAG_NAME', type: 'PT_TAG', defaultValue: 'main', description: 'The list existing tag', quickFilterEnabled: 'true', tagFilter: 'v*', sortMode: 'DESCENDING_SMART'
        string(name: 'VERSION', defaultValue: "", description: 'Release version. Format: <sx.y.z> x: major version, y: minor version, z: patch version')
        string(name: 'RELEASE_MSG', defaultValue: "", description: 'Release message')
        choice(name: 'GET_APPROVAL', choices: ['No', 'Yes'], description: 'Do you want to confirm before going to the next or not?')
        string(name: 'S3_BUCKET', defaultValue: 'vl-terraform-modules-prd-storage', description: 'S3 bucket that will be published using cloudfront to distribute')
        string(name: 'URL', defaultValue: 'https://devops-vl.vietlinkads.com', description: 'Link url of cloudfront to call module')    
        string(name: 'S3_FOLDER', defaultValue: 'codebuild-detect-change-terraform', description: 'S3 folder that will be published using cloudfront to distribute')     
    }
    
    stages {
        stage ('Checkout'){
            steps {
                script {
                    echo "Git checkout!!!"
                    checkout([$class: 'GitSCM', 
                            branches: [[name: "${params.BRANCH}"]], 
                            doGenerateSubmoduleConfigurations: false, 
                            extensions: [], 
                            submoduleCfg: [], 
                            userRemoteConfigs: [[credentialsId: 'sonlammgift', url: "git@bitbucket.org:devops-vl/aws-module-terraform-change-detector.git"]]])
                }
            }
        }
        stage ('Scanning') {
            steps {
                script {
                    ansiColor('xterm') {
                        Git_Scan()
                    }
                }
            }
        }
        stage('Creating tag!!!') {
                steps {
                    ansiColor('xterm') {
                        echo "Checking SCRIPT_NAME ${params.SCRIPT_NAME}"
                        echo "Checking GET_APPROVAL ${params.GET_APPROVAL}"
                    }
                    script{
                        get_approval_from_user("${params.GET_APPROVAL}")
                        withCredentials([sshUserPrivateKey(credentialsId: "sonlammgift", keyFileVariable: 'ssh_key')]) {
                        sh '''#!/bin/bash
                            echo "SCRIPT_NAME: ${COMPONENT_NAME}"
                            date=$(date '+%Y%m%d%H%M%S')
                            echo "Date: $date"
                            tag="${VERSION}"
                            echo "tag: ${VERSION}"
                            eval "$(ssh-agent -s)"
                            ssh-add ${ssh_key}
                            git config --global user.email "jenkins@vietlinkads.com"
                            git config --global user.name "jenkins"
                            git tag -a ${VERSION} ${BRANCH} -m "${RELEASE_MSG}"
                            git push origin ${VERSION}
                        '''
                        }  
                    }
                }
            }
        
        stage ('Publishing') {
            steps {
                script {
                    get_approval_from_user("${params.GET_APPROVAL}")
                    SCRIPT_NAME = params.VERSION ? "${SCRIPT_NAME}.${params.VERSION}" : SCRIPT_NAME

                    dir(params.SCRIPT_PATH){
                        sh """
                            aws s3 cp ${params.SCRIPT_NAME} s3://${params.S3_BUCKET}/private/${params.S3_FOLDER}/${SCRIPT_NAME}
                        """
                    }
                    println "${params.URL}/private/${params.S3_FOLDER}/${SCRIPT_NAME}?token=PLACEHOLDER"
                }
            }
        }
    }
    post {
        always {
            script {
                sendSlackNotifcation(buildStatus: "${currentBuild.result}") 
            }               
            
        }
    }
}

