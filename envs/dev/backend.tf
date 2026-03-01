# ------------------------------------------------------------------------------
# Terraform backend configuration for state management
# ------------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "project-tf-state-bucket"     # S3 bucket to store state file
    key            = "infrastructure/terraform.tfstate"    # Path inside the bucket
    region         = "us-east-1"                           # Region of the S3 bucket
    dynamodb_table = "project-tf-state-lock"       # DynamoDB table for state locking
    encrypt        = true                                  # Enable SSE for state file
  }
}
