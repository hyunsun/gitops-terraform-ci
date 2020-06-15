pipeline {
    agent none
    stages {
        stage('Build Temporary Image') {
            agent any
            environment {
                DOCKER_TAG = "temp-${GIT_COMMIT[0..7]}"
            }
            steps {
                withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
                    sh '''
                    docker build -f app/Dockerfile.server -t hyunsunmoon/edge-monitoring-server:${DOCKER_TAG} app
                    docker push hyunsunmoon/edge-monitoring-server:${DOCKER_TAG}
                    '''
                }
            }
        }
        stage('deploy') {
            agent {
                docker { image "golang:1.14"
                         args "-u root:root" }
            }
            environment {
                GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
                RANCHER_URL = "https://rancher-test.aetherproject.org"
                RANCHER_ACCESS_KEY = credentials('rancherAccessKey')
                RANCHER_SECRET_KEY = credentials('rancherSecretKey')
            }
            steps {
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
