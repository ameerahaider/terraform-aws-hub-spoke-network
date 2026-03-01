# ------------------------------------------------------------------------------
# Propagate default route from Network VPC to the post-inspection route table
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_propagation" "post_inspection_common" {
  transit_gateway_attachment_id  = var.network_attachment_id
  transit_gateway_route_table_id = var.post_inspection_rt_id
}

# ------------------------------------------------------------------------------
# Route in Pre-Inspection Route Table to send traffic to Network VPC
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "pre_inspect_to_common" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = var.pre_inspection_rt_id
  transit_gateway_attachment_id  = var.network_attachment_id
}

# ------------------------------------------------------------------------------
# Associate Dev VPC attachments to the Pre-Inspection route table
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "pre_inspection_dev" {
  count                          = length(var.dev_attachment_ids)
  transit_gateway_attachment_id  = var.dev_attachment_ids[count.index]
  transit_gateway_route_table_id = var.pre_inspection_rt_id
}

/*
# Propagate Dev VPC routes to pre-inspection
resource "aws_ec2_transit_gateway_route_table_propagation" "pre_inspection_dev" {
  count                          = length(var.dev_attachment_ids)
  transit_gateway_attachment_id  = var.dev_attachment_ids[count.index]
  transit_gateway_route_table_id = var.pre_inspection_rt_id
}
*/

# ------------------------------------------------------------------------------
# Create routes in Post-Inspection route table to return traffic to Dev VPC
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "post_inspect_to_dev" {
  count                          = length(var.dev_attachment_ids)
  destination_cidr_block         = var.dev_cidrs[count.index]
  transit_gateway_route_table_id = var.post_inspection_rt_id
  transit_gateway_attachment_id  = var.dev_attachment_ids[count.index]
}

# ------------------------------------------------------------------------------
# Associate Prod VPC attachments to the Pre-Inspection route table
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "pre_inspection_prod" {
  count                          = length(var.prod_attachment_ids)
  transit_gateway_attachment_id  = var.prod_attachment_ids[count.index]
  transit_gateway_route_table_id = var.pre_inspection_rt_id
}

/*
# Propagate prod VPC routes to pre-inspection
resource "aws_ec2_transit_gateway_route_table_propagation" "pre_inspection_prod" {
  count                          = length(var.prod_attachment_ids)
  transit_gateway_attachment_id  = var.prod_attachment_ids[count.index]
  transit_gateway_route_table_id = var.pre_inspection_rt_id
}
*/

# ------------------------------------------------------------------------------
# Create routes in Post-Inspection route table to return traffic to Prod VPC
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "post_inspect_to_prod" {
  count                          = length(var.prod_attachment_ids)
  destination_cidr_block         = var.prod_cidrs[count.index]
  transit_gateway_route_table_id = var.post_inspection_rt_id
  transit_gateway_attachment_id  = var.prod_attachment_ids[count.index]
}