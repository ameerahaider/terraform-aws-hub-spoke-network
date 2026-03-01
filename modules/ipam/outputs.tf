# ------------------------------------------------------------------------------
# Output: IPAM instance ID
# ------------------------------------------------------------------------------
output "ipam_id" {
  description = "ID of the IPAM instance"
  value       = aws_vpc_ipam.main.id
}

# ------------------------------------------------------------------------------
# Output: IPAM instance ARN
# ------------------------------------------------------------------------------
output "ipam_arn" {
  description = "ARN of the IPAM instance"
  value       = aws_vpc_ipam.main.arn
}

# ------------------------------------------------------------------------------
# Output: Networking pool ID
# ------------------------------------------------------------------------------
output "networking_pool_id" {
  description = "ID of the networking IPAM pool"
  value       = aws_vpc_ipam_pool.networking.id
}
