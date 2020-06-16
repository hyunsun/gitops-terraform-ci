pipeline {
    agent none
    stages {
        stage('Build Image') {
            agent any
            environment {
                DOCKER_REGISTRY = "docker.io/hyunsunmoon"
                DOCKER_TAG = "temp-${GIT_COMMIT[0..7]}"
            }
            steps {
                withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
                    sh '''
                    make docker-build
                    make docker-push
                    '''
                }
            }
        }
        stage('Terraform Init') {
            agent {
                dockerfile {
                    filename 'Dockerfile.tf'
                    args '-u root:root'
                }
            }
            environment {
                GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
                TF_VAR_rancher_url = "https://rancher-test.aetherproject.org"
                TF_VAR_rancher_access_key = credentials('rancherAccessKey')
                TF_VAR_rancher_secret_key = credentials('rancherSecretKey')
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
            agent {
                dockerfile {
                    filename 'Dockerfile.tf'
                    args '-u root:root'
                }
            }
            environment {
                DOCKER_REGISTRY = "docker.io/hyunsunmoon"
                DOCKER_TAG = "temp-${GIT_COMMIT[0..7]}"
                GOOGLE_BACKEND_CREDENTIALS = credentials('gcpCredential')
                TF_VAR_rancher_url = "https://rancher-test.aetherproject.org"
                TF_VAR_rancher_access_key = credentials('rancherAccessKey')
                TF_VAR_rancher_secret_key = credentials('rancherSecretKey')
            }
            steps {
                  /* This step needs to be improved to share this pipeline for all apps */
                  sh '''
                  cat >> jenkins.tfvars << EOF
                  edge_mon_docker_reg = "${DOCKER_REGISTRY}"
                  edge_mon_image_tag  = "${DOCKER_TAG}"
                  EOF 
                  cd terraform
                  terraform plan -out=plan -var-file=jenkins.tfvars
                  terraform apply plan
                  '''
            }
        }
        stage('Run Tests') {
            agent any
            steps {
                  sh '''
                  echo "Run some tests here..."
                  '''
            }
        }
        stage('Terraform Destroy') {
            agent {
                dockerfile {
                    filename 'Dockerfile.tf'
                    args '-u root:root'
                }
            }
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
