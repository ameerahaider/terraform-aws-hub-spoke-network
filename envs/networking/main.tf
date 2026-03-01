# ------------------------------------------------------------------------------
# AWS Provider Configuration
# ------------------------------------------------------------------------------
provider "aws" {
  region  = var.region
  profile = "default"
} 

# ------------------------------------------------------------------------------
# IPAM Setup
# - Provisions IPAM pools and shares with other accounts
# ------------------------------------------------------------------------------
module "ipam" {
  source = "../../modules/ipam"
  
  name           = var.name
  operating_regions   = [var.region]
  top_level_cidr     = "10.0.0.0/12"
  shared_account_ids = var.shared_account_ids
  
  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "ipam-setup"
  }
}

# ------------------------------------------------------------------------------
# VPC Inspection
# - Provisions the centralized inspection VPC using IPAM
# - Includes 2 public, 2 TGW, 2 inspection, and 2 VPN subnets and route tables
# - Includes 2 NAT Gateways
# - Includes Internet Gateway
# ------------------------------------------------------------------------------
module "vpc" {
  source             = "../../modules/vpc_inspection"
  name = var.name
  vpc_name           = var.vpc_name
  ipam_pool_id       = module.ipam.networking_pool_id
  vpc_netmask_length = var.vpc_netmask_length
  availability_zones = var.availability_zones
  environment        = var.environment
  subnet_groups      = var.subnet_groups
  firewall_endpoints = var.firewall_endpoints
  tags               = var.tags
}

# ------------------------------------------------------------------------------
# TGW Setup (Step 1)
# - Create Transit Gateway and share with Dev & Prod accounts
# - Attach the centralized Network VPC
# ------------------------------------------------------------------------------
module "tgw" {
  source          = "../../modules/tgw_inspection"
  name = var.name
  shared_account_ids = var.shared_account_ids
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.tgw_subnets_ids
  tags               = var.tags
}

// TGW Step 2: Create Attachments in Dev and Prod

# ------------------------------------------------------------------------------
# TGW Route Propagations (Step 3)
# - Associate Dev/QA/Prod VPCs with TGW route tables
# - Add routing to/from the centralized network VPC
# ------------------------------------------------------------------------------
module "tgw_propagation" {
  source          = "../../modules/tgw_inspection_propagation"
  pre_inspection_rt_id = module.tgw.pre_inspection_rt_id
  post_inspection_rt_id = module.tgw.post_inspection_rt_id
  
  network_attachment_id = module.tgw.network_attachment_id
  
  dev_attachment_ids = var.dev_attachment_ids
  dev_cidrs = var.dev_cidrs

  prod_attachment_ids = var.prod_attachment_ids
  prod_cidrs = var.prod_cidrs
}

# ------------------------------------------------------------------------------
# TGW Subnet Route Configuration
# - Creates routes in all VPC route tables (in both AZs) to send traffic to TGW
# ------------------------------------------------------------------------------
module "tgw_routes" {
  source          = "../../modules/tgw_inspection_routes"
  az1_rt_ids = module.vpc.az1_rt_ids
  az2_rt_ids = module.vpc.az2_rt_ids
  az1_subnet_cidrs = var.az1_subnet_cidrs
  az2_subnet_cidrs = var.az2_subnet_cidrs
  tgw_id = module.tgw.tgw_id
}

# ------------------------------------------------------------------------------
# Create SSM-related VPC Interface Endpoints in the workload VPC
# - Services: ec2messages, ssmmessages, ssm
# - Subnets: inspection subnets
# - Security Group: allows inbound traffic on port 443 from VPC CIDR
# ------------------------------------------------------------------------------
module "vpc_endpoints"{
  source          = "../../modules/vpc_endpoints"
  name = var.name
  region = var.region
  vpc_name = module.vpc.vpc_name
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr
  private_subnets_ids = module.vpc.inspection_subnets_ids
  environment        = var.environment
  tags               = var.tags
}