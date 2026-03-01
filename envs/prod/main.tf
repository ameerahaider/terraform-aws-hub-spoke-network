# ------------------------------------------------------------------------------
# AWS Provider Configuration
# ------------------------------------------------------------------------------
provider "aws" {
  region  = var.region
  profile = "default"
} 

# ------------------------------------------------------------------------------
# Create private VPC for application workload
# - Uses IPAM pool shared from the network account
# - Includes 2 private subnets and route tables
# ------------------------------------------------------------------------------
module "workload_vpc" {
  source             = "../../modules/vpc_spoke"
  name = var.name
  vpc_name           = var.workload_vpc_name
  ipam_pool_id       = var.workload_ipam_pool_id
  vpc_netmask_length = var.vpc_netmask_length
  availability_zones = var.availability_zones
  environment        = var.environment
  subnet_groups      = var.workload_subnet_groups
  tags               = var.tags
}

# ------------------------------------------------------------------------------
# Create private VPC for database layer
# - Uses IPAM pool shared from the network account
# - Includes 2 private subnets and route tables
# ------------------------------------------------------------------------------
module "db_vpc" {
  source             = "../../modules/vpc_spoke"
  name = var.name
  vpc_name           = var.db_vpc_name
  ipam_pool_id       = var.db_ipam_pool_id
  vpc_netmask_length = var.vpc_netmask_length
  availability_zones = var.availability_zones
  environment        = var.environment
  subnet_groups      = var.db_subnet_groups
  tags               = var.tags
}


# ------------------------------------------------------------------------------
# Attach workload VPC to Transit Gateway (TGW)
# - TGW is pre-created and shared via RAM from network account
# - Adds default routes (0.0.0.0/0) in workload VPC route tables pointing to TGW
# ------------------------------------------------------------------------------
module "tgw_workload" {
  source              = "../../modules/tgw_spoke"
  network_account_id  = var.network_account_id
  subnet_ids          = module.workload_vpc.subnets_ids
  vpc_id              = module.workload_vpc.vpc_id
  rt_ids              = module.workload_vpc.route_table_ids
  environment         = "workload"
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Attach database VPC to Transit Gateway (TGW)
# - TGW is pre-created and shared via RAM from network account
# - Adds default routes (0.0.0.0/0) in DB VPC route tables pointing to TGW
# ------------------------------------------------------------------------------
module "tgw_db" {
  source              = "../../modules/tgw_spoke"
  network_account_id  = var.network_account_id
  subnet_ids          = module.db_vpc.subnets_ids
  vpc_id              = module.db_vpc.vpc_id
  rt_ids              = module.db_vpc.route_table_ids
  environment         = "db"
  tags                = var.tags
}

# ------------------------------------------------------------------------------
# Create SSM-related VPC Interface Endpoints in the workload VPC
# - Services: ec2messages, ssmmessages, ssm
# - Subnets: workload private subnets
# - Security Group: allows inbound traffic on port 443 from VPC CIDR
# ------------------------------------------------------------------------------
module "workload_vpc_endpoints"{
  source          = "../../modules/vpc_endpoints"
  name = var.name
  region = var.region
  vpc_name = module.workload_vpc.vpc_name
  vpc_id = module.workload_vpc.vpc_id
  vpc_cidr_block = module.workload_vpc.vpc_cidr
  private_subnets_ids = module.workload_vpc.subnets_ids
  environment        = var.environment
  tags               = var.tags
}

# ------------------------------------------------------------------------------
# Create SSM-related VPC Interface Endpoints in the DB VPC
# - Services: ec2messages, ssmmessages, ssm
# - Subnets: database private subnets
# - Security Group: allows inbound traffic on port 443 from VPC CIDR
# ------------------------------------------------------------------------------
module "db_vpc_endpoints"{
  source          = "../../modules/vpc_endpoints"
  name = var.name
  region = var.region
  vpc_name = module.db_vpc.vpc_name
  vpc_id = module.db_vpc.vpc_id
  vpc_cidr_block = module.db_vpc.vpc_cidr
  private_subnets_ids = module.db_vpc.subnets_ids
  environment        = var.environment
  tags               = var.tags
}