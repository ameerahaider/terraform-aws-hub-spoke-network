# ------------------------------------------------------------------------------
# Create IPAM instance with multi-region support
# ------------------------------------------------------------------------------
resource "aws_vpc_ipam" "main" {
  description = "Main IPAM for organization"

  # Add the first region statically
  operating_regions {
    region_name = var.operating_regions[0]
  }

  # Dynamically add any remaining regions
  dynamic "operating_regions" {
    for_each = length(var.operating_regions) > 1 ? slice(var.operating_regions, 1, length(var.operating_regions)) : []
    content {
      region_name = operating_regions.value
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-ipam"
  })
}

# ------------------------------------------------------------------------------
# Top-level IPAM pool: Root pool for the organization
# ------------------------------------------------------------------------------
resource "aws_vpc_ipam_pool" "top_level" {
  address_family  = "ipv4"
  ipam_scope_id   = aws_vpc_ipam.main.private_default_scope_id
  description     = "Top level pool for entire organization"

  tags = merge(var.tags, {
    Name = "${var.name}-ipam-top-level"
  })
}

# CIDR allocation for the top-level pool
resource "aws_vpc_ipam_pool_cidr" "top_level" {
  ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  cidr         = var.top_level_cidr
}

# ------------------------------------------------------------------------------
# Create IPAM pools for each environment (networking, dev, prod, qa)
# Each pool inherits from the top-level pool
# ------------------------------------------------------------------------------

# Networking pool
resource "aws_vpc_ipam_pool" "networking" {
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  description         = "Pool for networking environment"
  locale              = var.operating_regions[0]

  tags = merge(var.tags, {
    Name        = "${var.name}-ipam-networking"
    Environment = "networking"
  })
}

resource "aws_vpc_ipam_pool_cidr" "networking" {
  ipam_pool_id = aws_vpc_ipam_pool.networking.id
  cidr         = "10.6.0.0/16"
}

# Dev workload pool
resource "aws_vpc_ipam_pool" "dev_workload" {
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  description         = "Pool for dev workload environment"
  locale              = var.operating_regions[0]

  tags = merge(var.tags, {
    Name        = "${var.name}-ipam-dev-workload"
    Environment = "dev"
    Type        = "workload"
  })
}

resource "aws_vpc_ipam_pool_cidr" "dev_workload" {
  ipam_pool_id = aws_vpc_ipam_pool.dev_workload.id
  cidr         = "10.2.0.0/16"
}

# Dev DB pool
resource "aws_vpc_ipam_pool" "dev_db" {
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  description         = "Pool for dev DB environment"
  locale              = var.operating_regions[0]

  tags = merge(var.tags, {
    Name        = "${var.name}-ipam-dev-db"
    Environment = "dev"
    Type        = "db"
  })
}

resource "aws_vpc_ipam_pool_cidr" "dev_db" {
  ipam_pool_id = aws_vpc_ipam_pool.dev_db.id
  cidr         = "10.3.0.0/16"
}

# Prod workload pool
resource "aws_vpc_ipam_pool" "prod_workload" {
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  description         = "Pool for prod workload environment"
  locale              = var.operating_regions[0]

  tags = merge(var.tags, {
    Name        = "${var.name}-ipam-prod-workload"
    Environment = "prod"
    Type        = "workload"
  })
}

resource "aws_vpc_ipam_pool_cidr" "prod_workload" {
  ipam_pool_id = aws_vpc_ipam_pool.prod_workload.id
  cidr         = "10.0.0.0/16"
}

# Prod DB pool
resource "aws_vpc_ipam_pool" "prod_db" {
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  description         = "Pool for prod DB environment"
  locale              = var.operating_regions[0]

  tags = merge(var.tags, {
    Name        = "${var.name}-ipam-prod-db"
    Environment = "prod"
    Type        = "db"
  })
}

resource "aws_vpc_ipam_pool_cidr" "prod_db" {
  ipam_pool_id = aws_vpc_ipam_pool.prod_db.id
  cidr         = "10.1.0.0/16"
}



# ------------------------------------------------------------------------------
# Resource Access Manager (RAM) Sharing of Pools with Target Accounts
# ------------------------------------------------------------------------------
resource "aws_ram_resource_share" "ipam_pools" {
  count                      = length(var.shared_account_ids) > 0 ? 1 : 0
  name                       = "${var.name}-ipam-pool-share"
  allow_external_principals = true

  tags = var.tags
}

# Associate individual pools with the RAM resource share
resource "aws_ram_resource_association" "dev_workload" {
  count              = length(var.shared_account_ids) > 0 ? 1 : 0
  resource_arn       = aws_vpc_ipam_pool.dev_workload.arn
  resource_share_arn = aws_ram_resource_share.ipam_pools[0].arn
}

resource "aws_ram_resource_association" "prod_workload" {
  count              = length(var.shared_account_ids) > 0 ? 1 : 0
  resource_arn       = aws_vpc_ipam_pool.prod_workload.arn
  resource_share_arn = aws_ram_resource_share.ipam_pools[0].arn
}

resource "aws_ram_resource_association" "dev_db_pool" {
  count              = length(var.shared_account_ids) > 0 ? 1 : 0
  resource_arn       = aws_vpc_ipam_pool.dev_db.arn
  resource_share_arn = aws_ram_resource_share.ipam_pools[0].arn
}

resource "aws_ram_resource_association" "prod_db_pool" {
  count              = length(var.shared_account_ids) > 0 ? 1 : 0
  resource_arn       = aws_vpc_ipam_pool.prod_db.arn
  resource_share_arn = aws_ram_resource_share.ipam_pools[0].arn
}

# Associate external AWS accounts with the RAM share
resource "aws_ram_principal_association" "accounts" {
  count              = length(var.shared_account_ids)
  principal          = var.shared_account_ids[count.index]
  resource_share_arn = aws_ram_resource_share.ipam_pools[0].arn
}
