pipeline{
    agent any
        
    stages {
        stage('Checkout') {
            steps {
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/balan77/webapp.git']]])            

          }
        }
        stage ("terraform_init"){
            steps{
            echo "Terraform in action --> validate"
                dir('terraform_resource') {
                    sh "sudo terraform init -upgrade"
                }
            }
        }
        stage ("validate"){
            steps{
                echo "Terraform in action --> validate"
                dir('terraform_resource') {
                    sh "sudo terraform validate"
                }
            }
        }
        stage ("plan"){
            steps{
                echo "Terraform plan begins..."
                dir ("terraform_resource") {
                sh "suod terraform plan -var-file prod.tfvars"
                }
            }
        }
        stage ("apply"){
            steps{
                echo "Terraform Apply begins..."
                dir ("terraform_resource") {
                sh "sudo terraform apply -var-file prod.tfvars -auto-approve"
                }
            }
        
        }
    }
