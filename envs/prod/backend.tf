# ------------------------------------------------------------------------------
# Terraform backend configuration for state management
# ------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "project-prod-tf-state-bucket"  
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "project-prod-tf-state-lock"         
    encrypt        = true
  }
}