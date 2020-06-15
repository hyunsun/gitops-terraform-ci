pipeline {
    agent none
    environment {
        GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
        RANCHER_URL = "https://rancher-test.aetherproject.org"
        RANCHER_ACCESS_KEY = credentials('rancherAccessKey')
        RANCHER_SECRET_KEY = credentials('rancherSecretKey')
    }  
    stages {
        // Install terraform
        stage('build') {
            agent any
            steps {
                sh 'docker images'
            }
        }
        stage('test') {
            agent {
                docker { image "golang:1.14"
                         args "-u root:root" }
            }
            steps{
                  sh '''
                  go get github.com/hashicorp/terraform
                  go install github.com/hashicorp/terraform
                  terraform version
                  cd terraform && terraform init
                  '''
            }
        }
    }
}
