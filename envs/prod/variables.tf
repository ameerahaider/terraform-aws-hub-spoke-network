# ------------------------------------------------------------------------------
# AWS region where resources will be deployed
# ------------------------------------------------------------------------------
variable "region" {
  description = "Region name"
  type        = string
}

# ------------------------------------------------------------------------------
# Deployment environment (e.g., dev, qa, prod)
# ------------------------------------------------------------------------------
variable "environment" {
  description = "Environment name"
  type        = string
}

# ------------------------------------------------------------------------------
# Name for the deployment used in tagging and resource naming
# ------------------------------------------------------------------------------
variable "name" {
  description = "Name for the VPC"
  type        = string
}

# ------------------------------------------------------------------------------
# Workload VPC name and IPAM pool
# ------------------------------------------------------------------------------
variable "workload_vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "workload_ipam_pool_id" {
  description = "IPAM pool ID to allocate VPC CIDR from"
  type        = string
}

# ------------------------------------------------------------------------------
# DB VPC name and IPAM pool
# ------------------------------------------------------------------------------
variable "db_vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "db_ipam_pool_id" {
  description = "IPAM pool ID to allocate VPC CIDR from"
  type        = string
}

# ------------------------------------------------------------------------------
# VPC Netmask length (e.g., 24 = /24 subnet mask)
# ------------------------------------------------------------------------------
variable "vpc_netmask_length" {
  description = "Netmask length for VPC CIDR (e.g., 24 for /24)"
  type        = number
}

# ------------------------------------------------------------------------------
# List of availability zones for subnet distribution
# ------------------------------------------------------------------------------
variable "availability_zones" {
  description = "List of availability zones (must match subnet counts)"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Subnet group configuration for workload VPC
# ------------------------------------------------------------------------------
variable "workload_subnet_groups" {
  description = "Configuration for public, tgw, and inspection subnets"
  type = object({
    subnet = object({
      name_prefix = string
      count       = number
    })
  })
}

# ------------------------------------------------------------------------------
# Subnet group configuration for DB VPC
# ------------------------------------------------------------------------------
variable "db_subnet_groups" {
  description = "Configuration for public, tgw, and inspection subnets"
  type = object({
    subnet = object({
      name_prefix = string
      count       = number
    })
  })
}

# ------------------------------------------------------------------------------
# Common tags to apply to all resources
# ------------------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# AWS account ID of the network account (used for TGW sharing, etc.)
# ------------------------------------------------------------------------------
variable "network_account_id" {
  description = "AWS account ID of Network Account"
  type        = string
}
