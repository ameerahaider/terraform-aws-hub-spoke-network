# ------------------------------------------------------------------------------
# Output: VPC name tag
# ------------------------------------------------------------------------------
output "vpc_name" {
  description = "The name tag of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

# ------------------------------------------------------------------------------
# Output: VPC ID
# ------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# ------------------------------------------------------------------------------
# Output: VPC CIDR block
# ------------------------------------------------------------------------------
output "vpc_cidr" {
  description = "The CIDR of the VPC"
  value       = aws_vpc.main.cidr_block
}

# ------------------------------------------------------------------------------
# Output: Public subnet IDs
# ------------------------------------------------------------------------------
output "public_subnets_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# ------------------------------------------------------------------------------
# Output: Transit Gateway subnet IDs
# ------------------------------------------------------------------------------
output "tgw_subnets_ids" {
  description = "The IDs of the TGW subnets"
  value       = aws_subnet.tgw[*].id
}

# ------------------------------------------------------------------------------
# Output: Inspection subnet IDs
# ------------------------------------------------------------------------------
output "inspection_subnets_ids" {
  description = "The IDs of the inspection subnets"
  value       = aws_subnet.inspection[*].id
}

# ------------------------------------------------------------------------------
# Output: Internet Gateway ID
# ------------------------------------------------------------------------------
output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.main.id
}

# ------------------------------------------------------------------------------
# Output: NAT Gateway ID (primary)
# ------------------------------------------------------------------------------
output "nat_gateway_id" {
  description = "The ID of the primary NAT gateway"
  value       = aws_nat_gateway.gw.id
}

# ------------------------------------------------------------------------------
# Output: All route table IDs (public, TGW, inspection, VPN client)
# ------------------------------------------------------------------------------
output "all_route_table_ids" {
  description = "List of all route table IDs (public, TGW, inspection, VPN client)"
  value = concat(
    [for rt in aws_route_table.public : rt.id],
    [for rt in aws_route_table.tgw : rt.id],
    [for rt in aws_route_table.inspection : rt.id],
    [for rt in aws_route_table.vpnclient : rt.id]
  )
}

# ------------------------------------------------------------------------------
# Output: Route table IDs in AZ 1 (Inspection and VPN Client)
# ------------------------------------------------------------------------------
output "az1_rt_ids" {
  description = "Route Table IDs in AZ 1"
  value = [
    //aws_route_table.public[0].id,
    //aws_route_table.tgw[0].id,
    aws_route_table.inspection[0].id,
    aws_route_table.vpnclient[0].id,
  ]
}

# ------------------------------------------------------------------------------
# Output: Route table IDs in AZ 2 (Inspection and VPN Client)
# ------------------------------------------------------------------------------
output "az2_rt_ids" {
  description = "Route Table IDs in AZ 2"
  value = [
    //aws_route_table.public[1].id,
    //aws_route_table.tgw[1].id,
    aws_route_table.inspection[1].id,
    aws_route_table.vpnclient[1].id,
  ]
}