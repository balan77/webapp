pipeline{
    agent{any}
    stages {
        stage('Checkout') {
            steps {
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/suresh-akidev/thala']]])            

          }
        }
        stage ("terraform_init"){
            steps{

            }
        }
        stage ("validate"){
            steps{
                echo "Terraform action is --> validate"
                dir('terraform_resources') {
                    sh "terraform validate"
                }
            }
        }
        stage ("plan"){
            steps{
                echo "Terraform plan begins..."
                dir ("terraform_resource") {
                sh "terraform plan -var-file prod.tfvars -auto-approve"
                }
            }
        }
        stage ("apply"){
            steps{
                echo "Terraform Apply begins..."
                sh "terraform apply -var-file prod.tfvars -auto-approve"
            }
        }
        
    }
}