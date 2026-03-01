# ------------------------------------------------------------------------------
# Region where resources will be deployed
# ------------------------------------------------------------------------------
variable "region" {
  description = "Region name"
  type        = string
}

# ------------------------------------------------------------------------------
# AWS Account IDs to share IPAM/TGW with (e.g., Dev, QA, Prod)
# ------------------------------------------------------------------------------
variable "shared_account_ids" {
  description = "AWS account IDs to share IPAM pools with"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Environment identifier (e.g., dev, qa, prod, network)
# ------------------------------------------------------------------------------
variable "environment" {
  description = "Environment name"
  type        = string
}

# ------------------------------------------------------------------------------
# VPC resource name for tagging and identification
# ------------------------------------------------------------------------------
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

# ------------------------------------------------------------------------------
# Common base name used across resources
# ------------------------------------------------------------------------------
variable "name" {
  description = "Name for the VPC"
  type        = string
}

# ------------------------------------------------------------------------------
# Netmask for the CIDR block allocated from IPAM (e.g., /24)
# ------------------------------------------------------------------------------
variable "vpc_netmask_length" {
  description = "Netmask length for VPC CIDR (e.g., 24 for /24)"
  type        = number
  default     = 24
}

# ------------------------------------------------------------------------------
# Availability Zones to spread subnets across
# ------------------------------------------------------------------------------
variable "availability_zones" {
  description = "List of availability zones (must match subnet counts)"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Subnet group configuration by type (public, tgw, inspection, vpnclient)
# ------------------------------------------------------------------------------
variable "subnet_groups" {
  description = "Configuration for public, tgw, and inspection subnets"
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
}

# ------------------------------------------------------------------------------
# Tags applied to all resources
# ------------------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Transit Gateway Attachment IDs (Dev VPCs)
# ------------------------------------------------------------------------------
variable "dev_attachment_ids" {
  description = "TGW attachment IDs for Dev VPCs"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Transit Gateway Attachment IDs (Prod VPCs)
# ------------------------------------------------------------------------------
variable "prod_attachment_ids" {
  description = "TGW attachment IDs for Prod VPCs"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# CIDR blocks for Dev VPCs
# ------------------------------------------------------------------------------
variable "dev_cidrs" {
  description = "CIDR blocks for Dev VPCs"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# CIDR blocks for Prod VPCs
# ------------------------------------------------------------------------------
variable "prod_cidrs" {
  description = "CIDR blocks for Prod VPCs"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Subnet CIDRs for AZ1 (used in routing)
# ------------------------------------------------------------------------------
variable "az1_subnet_cidrs" {
  description = "List of subnet CIDRs in AZ1"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Subnet CIDRs for AZ2 (used in routing)
# ------------------------------------------------------------------------------
variable "az2_subnet_cidrs" {
  description = "List of subnet CIDRs in AZ2"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# VPC Lattice Firewall endpoints for inspection
# ------------------------------------------------------------------------------
variable "firewall_endpoints" {
  description = "List of Firewall Endpoints"
  type        = list(string)
}
