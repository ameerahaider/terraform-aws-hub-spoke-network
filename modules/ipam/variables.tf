# ------------------------------------------------------------------------------
# Common identifier for naming IPAM resources
# ------------------------------------------------------------------------------
variable "name" {
  description = "Name for the VPC and IPAM resources"
  type        = string
}

# ------------------------------------------------------------------------------
# List of AWS regions for IPAM to operate in
# ------------------------------------------------------------------------------
variable "operating_regions" {
  description = "List of AWS regions where IPAM will operate"
  type        = list(string)
  default     = ["us-east-1", "us-west-2"]
}

# ------------------------------------------------------------------------------
# CIDR block for the top-level IPAM pool (organization-wide block)
# ------------------------------------------------------------------------------
variable "top_level_cidr" {
  description = "Top-level CIDR block for the entire organization"
  type        = string
  default     = "10.0.0.0/8"
}

# ------------------------------------------------------------------------------
# AWS account IDs to share IPAM pools with
# ------------------------------------------------------------------------------
variable "shared_account_ids" {
  description = "List of AWS account IDs to share IPAM pools with"
  type        = list(string)
  default     = []
}

# ------------------------------------------------------------------------------
# Tags to apply to IPAM and associated resources
# ------------------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to IPAM resources"
  type        = map(string)
  default     = {}
}
