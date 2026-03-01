# ------------------------------------------------------------------------------
# List of AWS Network Firewall endpoints (one per AZ)
# ------------------------------------------------------------------------------
variable "firewall_endpoints" {
  description = "List of Firewall Endpoints"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Common name identifier used in naming all resources
# ------------------------------------------------------------------------------
variable "name" {
  description = "Name for the Resources"
  type        = string
}

# ------------------------------------------------------------------------------
# Specific name tag to assign to the VPC
# ------------------------------------------------------------------------------
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

# ------------------------------------------------------------------------------
# IPAM Pool ID from which to allocate the VPC CIDR
# ------------------------------------------------------------------------------
variable "ipam_pool_id" {
  description = "IPAM pool ID to allocate CIDR from"
  type        = string
}

# ------------------------------------------------------------------------------
# Subnet mask for the VPC CIDR block (e.g., /24)
# ------------------------------------------------------------------------------
variable "vpc_netmask_length" {
  description = "Netmask length for VPC CIDR (e.g., 24 for /24)"
  type        = number
  default     = 24
}

# ------------------------------------------------------------------------------
# List of Availability Zones used to distribute subnets
# ------------------------------------------------------------------------------
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Environment name (e.g., dev, prod)
# ------------------------------------------------------------------------------
variable "environment" {
  description = "Environment name"
  type        = string
}

# ------------------------------------------------------------------------------
# Configuration object defining all subnet groups by type
# ------------------------------------------------------------------------------
variable "subnet_groups" {
  description = "Configuration for subnet groups"
  type = object({
    public = object({
      name_prefix = string
      count       = number
    })
    tgw = object({
      name_prefix = string
      count       = number
    })
    inspection = object({
      name_prefix = string
      count       = number
    })
    vpnclient = object({
      name_prefix = string
      count       = number
    })
  })
  default = {
    public = {
      name_prefix = "public"
      count       = 2
    }
    tgw = {
      name_prefix = "tgw"
      count       = 2
    }
    inspection = {
      name_prefix = "inspection"
      count       = 2
    }
    vpnclient = {
      name_prefix = "vpn-client"
      count       = 2
    }
  }
}

# ------------------------------------------------------------------------------
# Key-value tags applied to all created resources
# ------------------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
