# ------------------------------------------------------------------------------
# Core environment configuration
# ------------------------------------------------------------------------------
environment = "dev"
region      = "us-east-1"
name        = "project"

# ------------------------------------------------------------------------------
# VPC names and IPAM pools for workload and DB VPCs
# ------------------------------------------------------------------------------
workload_vpc_name     = "project-dev-workload-vpc"
workload_ipam_pool_id = "ipam-pool-ID"

db_vpc_name     = "project-dev-db-vpc"
db_ipam_pool_id = "ipam-pool-ID"

# ------------------------------------------------------------------------------
# CIDR configuration
# ------------------------------------------------------------------------------
vpc_netmask_length = 16

# ------------------------------------------------------------------------------
# Availability Zones for subnet distribution
# ------------------------------------------------------------------------------
availability_zones = ["us-east-1a", "us-east-1b"]

# ------------------------------------------------------------------------------
# Network account ID for cross-account TGW or RAM sharing
# ------------------------------------------------------------------------------
network_account_id = "<Network Account ID>"

# ------------------------------------------------------------------------------
# Subnet group configurations for workload VPC
# ------------------------------------------------------------------------------
workload_subnet_groups = {
  subnet = {
    name_prefix = "workload"
    count       = 2
  }
}

# ------------------------------------------------------------------------------
# Subnet group configurations for DB VPC
# ------------------------------------------------------------------------------
db_subnet_groups = {
  subnet = {
    name_prefix = "db"
    count       = 2
  }
}

# ------------------------------------------------------------------------------
# Common tags for all resources
# ------------------------------------------------------------------------------
tags = {
  Project   = "project"
  Owner     = "project"
  ManagedBy = "Terraform"
}
