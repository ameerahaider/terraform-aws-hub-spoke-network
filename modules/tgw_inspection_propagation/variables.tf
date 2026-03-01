# ------------------------------------------------------------------------------
# Pre-inspection route table ID used for VPC associations
# ------------------------------------------------------------------------------
variable "pre_inspection_rt_id" {
  type = string
}

# ------------------------------------------------------------------------------
# Post-inspection route table ID used for propagation and return routes
# ------------------------------------------------------------------------------
variable "post_inspection_rt_id" {
  type = string
}

# ------------------------------------------------------------------------------
# TGW attachment ID for the centralized Network VPC (used for inspection)
# ------------------------------------------------------------------------------
variable "network_attachment_id" {
  type = string
}

# ------------------------------------------------------------------------------
# TGW attachment IDs for Dev VPCs (multiple AZs)
# ------------------------------------------------------------------------------
variable "dev_attachment_ids" {
  type = list(string)
}

# ------------------------------------------------------------------------------
# TGW attachment IDs for Prod VPCs (multiple AZs)
# ------------------------------------------------------------------------------
variable "prod_attachment_ids" {
  type = list(string)
}

# ------------------------------------------------------------------------------
# List of CIDRs associated with Dev VPCs for return routing
# ------------------------------------------------------------------------------
variable "dev_cidrs" {
  type = list(string)
}

# ------------------------------------------------------------------------------
# List of CIDRs associated with Prod VPCs for return routing
# ------------------------------------------------------------------------------
variable "prod_cidrs" {
  type = list(string)
}
