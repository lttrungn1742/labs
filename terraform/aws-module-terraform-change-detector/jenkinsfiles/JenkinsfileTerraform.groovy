@Library('vietlink-jenkins-pipeline-library-dev') _

ci_cd_ModuleTerraform(
    git_repo: 'git@bitbucket.org:devops-vl/aws-module-terraform-change-detector.git', 
    MODULE_NAME: "aws-module-terraform-change-detector", 
    BRANCH: ["origin/master", "origin/develop"]
)
