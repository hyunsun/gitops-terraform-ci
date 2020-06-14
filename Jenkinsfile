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
        stage('init') {
            steps{
                  sh '''
                  go get github.com/hashicorp/terraform
                  go install github.com/hashicorp/terraform
                  terraform version
                  terraform init
                  '''
            }
        }
    }
}
