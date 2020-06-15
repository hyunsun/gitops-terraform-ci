pipeline {
    agent none
    stages {
        stage('Build Image') {
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
        stage('Terraform Init') {
            agent { dockerfile true }
            environment {
                GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
            }
            steps {
                  sh '''
                  cd terraform
                  terraform init
                  terraform destroy -auto-approve
                  '''
            }
        }
        stage('Terraform Plan and Apply') {
            agent { dockerfile true }
            environment {
                DOCKER_TAG = "temp-${GIT_COMMIT[0..7]}"
                GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
                TF_VAR_rancher_url = "https://rancher-test.aetherproject.org"
                TF_VAR_rancher_access_key = credentials('rancherAccessKey')
                TF_VAR_rancher_secret_key = credentials('rancherSecretKey')
            }
            steps {
                  sh '''
                  cd terraform
                  terraform plan -out plan
                  terraform apply plan
                  '''
            }
        }
        stage('Run Tests') {
            agent any
            steps {
                  sh '''
                  echo "Run tests here..."
                  '''
            }
        }
        stage('Terraform Destroy') {
            agent { dockerfile true }
            environment {
                GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
                TF_VAR_rancher_url = "https://rancher-test.aetherproject.org"
                TF_VAR_rancher_access_key = credentials('rancherAccessKey')
                TF_VAR_rancher_secret_key = credentials('rancherSecretKey')
            }
            steps {
                  sh '''
                  cd terraform
                  terraform destroy -auto-approve
                  '''
            }
        }
    }
}
