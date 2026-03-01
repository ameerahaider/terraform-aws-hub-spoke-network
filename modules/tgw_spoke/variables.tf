// ----------------------------------------------------------------------------
// AWS account ID of the Network account where TGW resides
// ----------------------------------------------------------------------------
variable "network_account_id" {
  description = "AWS account ID of Network Account"
  type        = string
}

// ----------------------------------------------------------------------------
// Subnet IDs for TGW attachment (one private subnet per AZ recommended)
// ----------------------------------------------------------------------------
variable "subnet_ids" {
  description = "Subnets for the attachment (one per AZ)"
  type        = list(string)
}

// ----------------------------------------------------------------------------
// VPC ID to be attached to the Transit Gateway
// ----------------------------------------------------------------------------
variable "vpc_id" {
  description = "The VPC to attach to TGW"
  type        = string
}

// ----------------------------------------------------------------------------
// Environment tag to distinguish workloads (e.g., dev, prod)
// ----------------------------------------------------------------------------
variable "environment" {
  type = string
}

// ----------------------------------------------------------------------------
// List of route table IDs where TGW routes will be added
// ----------------------------------------------------------------------------
variable "rt_ids" {
  type = list(string)
}

// ----------------------------------------------------------------------------
// Tags to be applied to all created resources
// ----------------------------------------------------------------------------
variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
