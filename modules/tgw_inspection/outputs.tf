# ------------------------------------------------------------------------------
# Output: TGW VPC attachment ID (Network account attachment)
# ------------------------------------------------------------------------------
output "network_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.common_egress.id
}

# ------------------------------------------------------------------------------
# Output: Pre-inspection TGW route table ID
# ------------------------------------------------------------------------------
output "pre_inspection_rt_id" {
  value = aws_ec2_transit_gateway_route_table.pre_inspection.id
}

# ------------------------------------------------------------------------------
# Output: Post-inspection TGW route table ID
# ------------------------------------------------------------------------------
output "post_inspection_rt_id" {
  value = aws_ec2_transit_gateway_route_table.post_inspection.id
}

# ------------------------------------------------------------------------------
# Output: Transit Gateway ID
# ------------------------------------------------------------------------------
output "tgw_id" {
  value = aws_ec2_transit_gateway.main.id
}
