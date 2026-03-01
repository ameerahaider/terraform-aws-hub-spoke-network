# ------------------------------------------------------------------------------
# VPC metadata and naming
# ------------------------------------------------------------------------------
variable "name" {
  description = "Base name used for naming resources"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

# ------------------------------------------------------------------------------
# IPAM configuration for VPC CIDR block allocation
# ------------------------------------------------------------------------------
variable "ipam_pool_id" {
  description = "IPAM pool ID to allocate CIDR from"
  type        = string
}

variable "vpc_netmask_length" {
  description = "Netmask length for VPC CIDR (e.g., 24 for /24)"
  type        = number
  default     = 24
}

# ------------------------------------------------------------------------------
# Availability zones to create subnets in
# ------------------------------------------------------------------------------
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Logical environment (e.g., dev, prod)
# ------------------------------------------------------------------------------
variable "environment" {
  description = "Environment name"
  type        = string
}

# ------------------------------------------------------------------------------
# Subnet group configuration
# - name_prefix: prefix to use for naming subnets
# - count: number of subnets to create
# ------------------------------------------------------------------------------
variable "subnet_groups" {
  description = "Configuration for subnet groups"
  type = object({
    subnet = object({
      name_prefix = string
      count       = number
    })
  })
  default = {
    subnet = {
      name_prefix = "workload"
      count       = 2
    }
  }
}

# ------------------------------------------------------------------------------
# Common tags to apply to all resources
# ------------------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}