# ------------------------------------------------------------------------------
# Transit Gateway ID to route traffic to
# ------------------------------------------------------------------------------
variable "tgw_id" {
  type = string
}

# ------------------------------------------------------------------------------
# Route table IDs for AZ1 (e.g., Inspection and VPN subnets in AZ1)
# ------------------------------------------------------------------------------
variable "az1_rt_ids" {
  type = list(string)
}

# ------------------------------------------------------------------------------
# Route table IDs for AZ2 (e.g., Inspection and VPN subnets in AZ2)
# ------------------------------------------------------------------------------
variable "az2_rt_ids" {
  type = list(string)
}

# ------------------------------------------------------------------------------
# Subnet CIDRs for AZ1 (used as destinations in route tables)
# ------------------------------------------------------------------------------
variable "az1_subnet_cidrs" {
  type = list(string)
}

# ------------------------------------------------------------------------------
# Subnet CIDRs for AZ2 (used as destinations in route tables)
# ------------------------------------------------------------------------------
variable "az2_subnet_cidrs" {
  type = list(string)
}
