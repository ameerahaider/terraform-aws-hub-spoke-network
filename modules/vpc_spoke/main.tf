# ------------------------------------------------------------------------------
# Create a VPC using IPAM with dynamic CIDR allocation
# ------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  ipv4_ipam_pool_id    = var.ipam_pool_id
  ipv4_netmask_length  = var.vpc_netmask_length
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

# ------------------------------------------------------------------------------
# Local values for calculating and assigning subnet CIDRs
# ------------------------------------------------------------------------------
locals {
  vpc_cidr = aws_vpc.main.cidr_block

  # Total number of subnets to create (e.g., workload + db subnets)
  total_subnets = var.subnet_groups.subnet.count

  # Bits to add to VPC netmask for subnetting (adjust to control subnet size)
  subnet_newbits = 1

  # Generate a list of subnet CIDRs from the VPC CIDR
  all_subnet_cidrs = [for i in range(local.total_subnets) : 
    cidrsubnet(local.vpc_cidr, local.subnet_newbits, i)
  ]

  # Final list of subnet CIDRs to assign to subnets
  subnet_cidrs = slice(local.all_subnet_cidrs, 0, local.total_subnets)
}

# ------------------------------------------------------------------------------
# Create private workload subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "subnet" {
  count                   = var.subnet_groups.subnet.count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.subnet_groups.subnet.name_prefix}-${count.index + 1}"
    Environment = var.environment
    Type        = "Public"
    AZ          = var.availability_zones[count.index]
  })
}

# ------------------------------------------------------------------------------
# Create route tables for each subnet
# ------------------------------------------------------------------------------
resource "aws_route_table" "rt" {
  count  = var.subnet_groups.subnet.count
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-${var.subnet_groups.subnet.name_prefix}-rt-${count.index + 1}"
  }
}

# ------------------------------------------------------------------------------
# Associate each subnet with its corresponding route table
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "rt" {
  count          = var.subnet_groups.subnet.count
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.rt[count.index].id
}
