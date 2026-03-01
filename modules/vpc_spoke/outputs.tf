# ------------------------------------------------------------------------------
# Output: VPC name (from tags)
# ------------------------------------------------------------------------------
output "vpc_name" {
  description = "The Name tag of the VPC"
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
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# ------------------------------------------------------------------------------
# Output: Subnet IDs created in the VPC
# ------------------------------------------------------------------------------
output "subnets_ids" {
  description = "The IDs of the subnets created in the VPC"
  value       = aws_subnet.subnet[*].id
}

# ------------------------------------------------------------------------------
# Output: Route table IDs created for the subnets
# ------------------------------------------------------------------------------
output "route_table_ids" {
  description = "List of route table IDs created for the subnets"
  value       = [for rt in aws_route_table.rt : rt.id]
}
