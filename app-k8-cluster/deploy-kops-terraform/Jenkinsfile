pipeline {

    agent {
    kubernetes(k8sagent(name: 'mini+terraform'))
  }
options
    {
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
      environment 
    {
        S3CRD = ''
    }
  stages {

     stage('Build And Push Docker image To ECR'){
       steps {
            container('docker') {
                
                // Initialize the plan 
                sh  """
                   docker build -t public.ecr.aws/l4h1v9n3/terraform-iac -f tf-docker-image/Dockerfile .

                   docker push public.ecr.aws/l4h1v9n3/terraform-iac
                   """
                }
            }
        }

         
   stage('Terraform init'){
       steps {
            container('terraform-iac') {
                
                // Initialize the plan 
                sh  """
                    export TF_LOG=TRACE
                    terraform init -input=false
                   """
                }
            }
        }

stage('Terraform plan'){
    steps {
            container('terraform-iac') {  
                
                sh "terraform plan -out=tfplan -input=false"
                
                //sh (script:"cd terraform-plans/create-vmss-from-image && terraform plan -out=tfplan -input=false -var 'terraform_resource_group='$vmss_rg -var 'terraform_vmss_name='$vmss_name -var 'terraform_azure_region='$location -var 'terraform_image_id='$image_id")
                }      
            }
        }
       
        stage('Terraform apply'){
            steps {
            container('terraform-iac') {
                
                // Apply the plan
                sh  """  
                   echo "terraform apply"
                    terraform apply -input=false -auto-approve "tfplan"
                   """
                }
            }
        }
        //stage('Upload tfstate'){
        //    container('terraform') {
        //        // Upload the state of the plan to s3 bucket.
        //        sh (script: "cd terraform-plans/create-vmss-from-image && tar -czvf ~/workspace/${env.JOB_NAME}/$deployment'.tar.gz' .")
        //        sh "pwd"
                
       //     }
       // }
    }

} 
