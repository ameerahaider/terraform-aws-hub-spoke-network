# ------------------------------------------------------------------------------
# Terraform backend configuration for state management
# ------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "project-network-tf-state-bucket"  
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "project-network-tf-state-lock"         
    encrypt        = true
  }
}