# ------------------------------------------------------------------------------
# Create a VPC using IPAM CIDR allocation
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
# Local values for subnet CIDR calculation
# ------------------------------------------------------------------------------
locals {
  vpc_cidr = aws_vpc.main.cidr_block

  # Total subnets = public + tgw + inspection + vpnclient
  total_subnets = var.subnet_groups.public.count + var.subnet_groups.tgw.count + var.subnet_groups.inspection.count + var.subnet_groups.vpnclient.count

  # Allocate /27 subnets (8 usable IPs for testing / small infra)
  subnet_newbits = 3

  # Calculate list of CIDRs for all subnets
  all_subnet_cidrs = [for i in range(local.total_subnets) :
    cidrsubnet(local.vpc_cidr, local.subnet_newbits, i)
  ]

  # Slice CIDRs for each subnet group
  public_subnet_cidrs     = slice(local.all_subnet_cidrs, 0, var.subnet_groups.public.count)
  tgw_subnet_cidrs        = slice(local.all_subnet_cidrs, var.subnet_groups.public.count, var.subnet_groups.public.count + var.subnet_groups.tgw.count)
  inspection_subnet_cidrs = slice(local.all_subnet_cidrs, var.subnet_groups.public.count + var.subnet_groups.tgw.count, var.subnet_groups.public.count + var.subnet_groups.tgw.count + var.subnet_groups.inspection.count)
  vpn_client_subnet_cidrs = slice(local.all_subnet_cidrs, var.subnet_groups.public.count + var.subnet_groups.tgw.count + var.subnet_groups.inspection.count, local.total_subnets)
}

# ------------------------------------------------------------------------------
# Public subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count                   = var.subnet_groups.public.count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.subnet_groups.public.name_prefix}-${count.index + 1}"
    Environment = var.environment
    Type        = "Public"
    AZ          = var.availability_zones[count.index]
  })
}

# ------------------------------------------------------------------------------
# TGW subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "tgw" {
  count             = var.subnet_groups.tgw.count
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.tgw_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.subnet_groups.tgw.name_prefix}-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
    AZ          = var.availability_zones[count.index]
  })
}

# ------------------------------------------------------------------------------
# Inspection subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "inspection" {
  count             = var.subnet_groups.inspection.count
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.inspection_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.subnet_groups.inspection.name_prefix}-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
    AZ          = var.availability_zones[count.index]
  })
}

# ------------------------------------------------------------------------------
# VPN Client subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "vpnclient" {
  count             = var.subnet_groups.vpnclient.count
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.vpn_client_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.subnet_groups.vpnclient.name_prefix}-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
    AZ          = var.availability_zones[count.index]
  })
}


# ------------------------------------------------------------------------------
# Public route tables
# ------------------------------------------------------------------------------
resource "aws_route_table" "public" {
  count  = length(aws_subnet.public)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-public-rt-${count.index + 1}"
  }
}

# ------------------------------------------------------------------------------
# Public route: 0.0.0.0/0 -> Internet Gateway
# ------------------------------------------------------------------------------
resource "aws_route" "public_route" {
  count                   = length(aws_route_table.public)
  route_table_id          = aws_route_table.public[count.index].id
  gateway_id              = aws_internet_gateway.main.id
  destination_cidr_block  = "0.0.0.0/0"
}

# ------------------------------------------------------------------------------
# Public route: Internal traffic -> Firewall Endpoint
# ------------------------------------------------------------------------------
resource "aws_route" "public_route1" {
  route_table_id          = aws_route_table.public[0].id
  vpc_endpoint_id         = var.firewall_endpoints[0]
  destination_cidr_block  = "10.0.0.0/8"
}

resource "aws_route" "public_route2" {
  route_table_id          = aws_route_table.public[1].id
  vpc_endpoint_id         = var.firewall_endpoints[1]
  destination_cidr_block  = "10.0.0.0/8"
}


# ------------------------------------------------------------------------------
# TGW route tables
# ------------------------------------------------------------------------------
resource "aws_route_table" "tgw" {
  count  = length(aws_subnet.tgw)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-tgw-rt-${count.index + 1}"
  }
}

# ------------------------------------------------------------------------------
# TGW route: Default route -> Firewall Endpoint
# ------------------------------------------------------------------------------
resource "aws_route" "tgw_route1" {
  route_table_id          = aws_route_table.tgw[0].id
  vpc_endpoint_id         = var.firewall_endpoints[0]
  destination_cidr_block  = "0.0.0.0/0"
}

resource "aws_route" "tgw_route2" {
  route_table_id          = aws_route_table.tgw[1].id
  vpc_endpoint_id         = var.firewall_endpoints[1]
  destination_cidr_block  = "0.0.0.0/0"
}

# ------------------------------------------------------------------------------
# Inspection route tables
# ------------------------------------------------------------------------------
resource "aws_route_table" "inspection" {
  count  = length(aws_subnet.inspection)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-inspection-rt-${count.index + 1}"
  }
}

# ------------------------------------------------------------------------------
# Inspection route: Default route -> NAT Gateway
# ------------------------------------------------------------------------------
resource "aws_route" "inspection_route1" {
  route_table_id          = aws_route_table.inspection[0].id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.gw.id
}

resource "aws_route" "inspection_route2" {
  route_table_id          = aws_route_table.inspection[1].id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.gw2.id
}

# ------------------------------------------------------------------------------
# VPN client route tables
# ------------------------------------------------------------------------------
resource "aws_route_table" "vpnclient" {
  count  = length(aws_subnet.vpnclient)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-vpn-client-rt-${count.index + 1}"
  }
}

# ------------------------------------------------------------------------------
# VPN client route: Default route -> Firewall Endpoint
# ------------------------------------------------------------------------------
resource "aws_route" "vpnclient_route1" {
  route_table_id          = aws_route_table.vpnclient[0].id
  vpc_endpoint_id         = var.firewall_endpoints[0]
  destination_cidr_block  = "0.0.0.0/0"
}

resource "aws_route" "vpnclient_route2" {
  route_table_id          = aws_route_table.vpnclient[1].id
  vpc_endpoint_id         = var.firewall_endpoints[1]
  destination_cidr_block  = "0.0.0.0/0"
}

# ------------------------------------------------------------------------------
# Associate public subnets with public route tables
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# ------------------------------------------------------------------------------
# Associate TGW subnets with TGW route tables
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "tgw_subnet_association" {
  count          = length(aws_subnet.tgw)
  subnet_id      = aws_subnet.tgw[count.index].id
  route_table_id = aws_route_table.tgw[count.index].id
}

# ------------------------------------------------------------------------------
# Associate inspection subnets with inspection route tables
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "inspection_subnet_association" {
  count          = length(aws_subnet.inspection)
  subnet_id      = aws_subnet.inspection[count.index].id
  route_table_id = aws_route_table.inspection[count.index].id
}

# ------------------------------------------------------------------------------
# Associate VPN client subnets with VPN client route tables
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "vpnclient_subnet_association" {
  count          = length(aws_subnet.vpnclient)
  subnet_id      = aws_subnet.vpnclient[count.index].id
  route_table_id = aws_route_table.vpnclient[count.index].id
}

# ------------------------------------------------------------------------------
# Internet Gateway for public subnets
# ------------------------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# ------------------------------------------------------------------------------
# Elastic IPs for NAT Gateways
# ------------------------------------------------------------------------------
resource "aws_eip" "gw" {
  tags = {
    Name = "${var.name}-nat1-eip"
  }
}

resource "aws_eip" "gw2" {
  tags = {
    Name = "${var.name}-nat2-eip"
  }
}

# ------------------------------------------------------------------------------
# NAT Gateways for outbound access from private subnets
# ------------------------------------------------------------------------------
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.gw.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.name}-nat-gateway1"
  }
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.gw2.id
  subnet_id     = aws_subnet.public[1].id

  tags = {
    Name = "${var.name}-nat-gateway2"
  }
}
