# ------------------------------------------------------------------------------
# Create the centralized Transit Gateway
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "main" {
  description                      = "Central TGW for organization"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = merge(var.tags, {
    Name        = "${var.name}-central-tgw"
    Environment = "network"
  })
}

# ------------------------------------------------------------------------------
# Create Pre-Inspection Route Table
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "pre_inspection" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = merge(var.tags, {
    Name = "${var.name}-pre-inspection-rt"
  })
}

# ------------------------------------------------------------------------------
# Create Post-Inspection Route Table
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "post_inspection" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = merge(var.tags, {
    Name = "${var.name}-post-inspection-rt"
  })
}

# ------------------------------------------------------------------------------
# Share Transit Gateway with other accounts (e.g., Dev and Prod)
# ------------------------------------------------------------------------------
resource "aws_ram_resource_share" "main" {
  name                     = "${var.name}-TGW-share"
  allow_external_principals = true
}

# ------------------------------------------------------------------------------
# Associate each shared account as a principal to the TGW resource share
# ------------------------------------------------------------------------------
resource "aws_ram_principal_association" "principals" {
  count              = length(var.shared_account_ids)
  principal          = var.shared_account_ids[count.index]
  resource_share_arn = aws_ram_resource_share.main.arn
}

# ------------------------------------------------------------------------------
# Associate the TGW with the resource share
# ------------------------------------------------------------------------------
resource "aws_ram_resource_association" "tgw" {
  count              = length(var.shared_account_ids)
  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.main.arn
}

# ------------------------------------------------------------------------------
# Attach the Network VPC to TGW for central egress/inspection
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "common_egress" {
  subnet_ids              = var.subnet_ids
  transit_gateway_id      = aws_ec2_transit_gateway.main.id
  vpc_id                  = var.vpc_id
  appliance_mode_support  = "enable"  # Required for traffic inspection

  tags = merge(var.tags, {
    Name = "${var.name}-network-to-tgw"
  })
}

# ------------------------------------------------------------------------------
# Associate the Network VPC attachment with the Post-Inspection route table
# ------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "post_inspection_network" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.common_egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post_inspection.id
}
