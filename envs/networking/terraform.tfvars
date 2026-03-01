# ------------------------------------------------------------------------------
# Shared Account IDs
# - Dev, Prod, and QA accounts that need access to shared IPAM/TGW resources
# ------------------------------------------------------------------------------
shared_account_ids = [
  "<Dev Account ID>",  # Replace with your dev account ID
  "<Prod Account ID>"   # Replace with your prod account ID
]

# ------------------------------------------------------------------------------
# Core environment configuration
# ------------------------------------------------------------------------------
environment        = "network"
region = "us-east-1"
name               = "project"

# ------------------------------------------------------------------------------
# VPC name
# ------------------------------------------------------------------------------
vpc_name           = "project-network-vpc"

# ------------------------------------------------------------------------------
# CIDR configuration
# ------------------------------------------------------------------------------
vpc_netmask_length = 24


# ------------------------------------------------------------------------------
# Availability Zones for subnet distribution
# ------------------------------------------------------------------------------
availability_zones = ["us-east-1a", "us-east-1b"]


# ------------------------------------------------------------------------------
# Subnet group configurations
# ------------------------------------------------------------------------------
subnet_groups = {
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


# ------------------------------------------------------------------------------
# Common tags for all resources
# ------------------------------------------------------------------------------
tags = {
  Project     = "project"
  Owner       = "project"
  ManagedBy   = "Terraform"
}

# ------------------------------------------------------------------------------
# Transit Gateway Attachment IDs and CIDRs
# For Dev Environment
# ------------------------------------------------------------------------------
dev_attachment_ids = [
  "tgw-attach-ID", //workload
  "tgw-attach-ID" //db
]

dev_cidrs = [
  "10.2.0.0/16", //workload
  "10.3.0.0/16" //db
]

# ------------------------------------------------------------------------------
# Transit Gateway Attachment IDs and CIDRs
# For Prod Environment
# ------------------------------------------------------------------------------
prod_attachment_ids = [
  "tgw-attach-ID", //workload
  "tgw-attach-ID" //db
]

prod_cidrs = [
  "10.0.0.0/16", //workload
  "10.1.0.0/16" //db
]

# ------------------------------------------------------------------------------
# VPC Lattice Firewall Endpoints
# ------------------------------------------------------------------------------
firewall_endpoints = [
  "vpce-ID", //prod
  "vpce-ID" //dev  
]

# ------------------------------------------------------------------------------
# Subnet CIDRs by Availability Zone for Routing
# ------------------------------------------------------------------------------
az1_subnet_cidrs = [
  "10.1.0.0/17", //prod DB
  "10.0.0.0/17", //prod Workload
  "10.3.0.0/17", //Dev DB
  "10.2.0.0/17", //Dev Workload
]

az2_subnet_cidrs = [
  "10.1.128.0/17", //prod DB
  "10.0.128.0/17", //prod Workload
  "10.3.128.0/17", //Dev DB
  "10.2.128.0/17", //Dev Workload
]



