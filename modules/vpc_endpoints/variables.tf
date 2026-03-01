# ------------------------------------------------------------------------------
# General Naming and Context Variables
# ------------------------------------------------------------------------------
variable "name" {
  description = "Base name used for tagging and naming resources"
  type        = string
}

variable "region" {
  description = "AWS region where the resources will be created"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (used in tagging)"
  type        = string
}

# ------------------------------------------------------------------------------
# VPC and Subnet Configuration
# ------------------------------------------------------------------------------
variable "vpc_cidr_block" {
  description = "CIDR block of the VPC used for SG ingress rules"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the VPC endpoints will be created"
  type        = string
}

variable "private_subnets_ids" {
  description = "List of private subnet IDs to use for VPC endpoints"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Environment Tag and Common Tags
# ------------------------------------------------------------------------------
variable "environment" {
  description = "Environment label (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
