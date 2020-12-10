# #########################################################
# Specify backend to store the terraform state file
#   - DynamoDB lock table with LockID string as primary key

terraform {
  backend "s3" {
    bucket         = "terraform-devops-eu-west-1-000000000000"
    key            = "application-infrastructure/terraform/application-specific-resources.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-locktable"
  }
}
