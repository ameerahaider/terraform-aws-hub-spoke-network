# ------------------------------------------------------------------------------
# Local values to generate TGW route combinations per AZ
# ------------------------------------------------------------------------------

# Generate route table + CIDR combinations for AZ1
locals {
  az1_routes = flatten([
    for rt_id in var.az1_rt_ids : [
      for cidr in var.az1_subnet_cidrs : {
        route_table_id         = rt_id
        destination_cidr_block = cidr
        az                     = "az1"
      }
    ]
  ])

  # Generate route table + CIDR combinations for AZ2
  az2_routes = flatten([
    for rt_id in var.az2_rt_ids : [
      for cidr in var.az2_subnet_cidrs : {
        route_table_id         = rt_id
        destination_cidr_block = cidr
        az                     = "az2"
      }
    ]
  ])

  # Combine all route mappings from both AZs
  all_routes = concat(local.az1_routes, local.az2_routes)
}

# ------------------------------------------------------------------------------
# Create TGW routes for all subnet CIDRs in each route table
# ------------------------------------------------------------------------------
resource "aws_route" "to_tgw" {
  for_each = {
    for idx, route in local.all_routes :
    "${route.az}-${route.route_table_id}-${replace(route.destination_cidr_block, "/", "-")}" => route
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = var.tgw_id
}
