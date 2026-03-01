// -----------------------------------------------------------------------------
// Data source: Fetch the shared Transit Gateway (TGW) from the Network account
// -----------------------------------------------------------------------------
data "aws_ec2_transit_gateway" "shared_tgw" {
  filter {
    name   = "owner-id"
    values = [var.network_account_id]
  }
}

# ------------------------------------------------------------------------------
# Resource: Create a Transit Gateway VPC attachment
# - Attaches the specified VPC and subnets to the shared TGW
# - Enables appliance mode for use cases like inspection/firewalling
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_to_tgw" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = data.aws_ec2_transit_gateway.shared_tgw.id
  vpc_id             = var.vpc_id
  appliance_mode_support = "enable"

  tags = merge(var.tags, {
    Name = "${var.environment}-to-tgw"
  })
}

# ------------------------------------------------------------------------------
# Resource: Create default routes in the specified route tables pointing to TGW
# - Each route table will get a 0.0.0.0/0 route via the Transit Gateway
# ------------------------------------------------------------------------------
resource "aws_route" "workload_subnet_to_tgw" {
  count = length(var.rt_ids)

  route_table_id         = var.rt_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.shared_tgw.id
}
