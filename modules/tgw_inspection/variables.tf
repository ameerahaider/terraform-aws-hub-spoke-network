# ------------------------------------------------------------------------------
# Common name identifier used in naming TGW and route table resources
# ------------------------------------------------------------------------------
variable "name" {
  description = "Name for the VPC"
  type        = string
}

# ------------------------------------------------------------------------------
# List of AWS account IDs to share the Transit Gateway with
# ------------------------------------------------------------------------------
variable "shared_account_ids" {
  description = "AWS account IDs to share TGW pools with"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# VPC ID of the Network account to attach to the Transit Gateway
# ------------------------------------------------------------------------------
variable "vpc_id" {
  description = "The VPC to attach to TGW"
  type        = string
}

# ------------------------------------------------------------------------------
# Subnet IDs (one per AZ) used for the TGW VPC attachment
# ------------------------------------------------------------------------------
variable "subnet_ids" {
  description = "Subnets for the attachment (one per AZ)"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Tags to apply to all TGW-related resources
# ------------------------------------------------------------------------------
variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
