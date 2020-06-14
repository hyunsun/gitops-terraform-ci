pipeline {
    agent {
        docker { image "golang:1.14"
                 args "-u root:root" }
    }
    environment {
        GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
    }  
    stages {
        // Install terraform
        stage('install') {
            steps{
                  sh '''
                  go get github.com/hashicorp/terraform
                  go install github.com/hashicorp/terraform
                  terraform version
                  '''
            }
        }
        stage('init') {
            steps{
                  sh '''
                  terraform init
                  '''
            }
        }
    }
}
