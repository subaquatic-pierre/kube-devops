# ---------------------------------------------------------------------------------------------------------------------
# VPC MODULE - Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with the VPC"
  value       = aws_vpc.this.main_route_table_id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs attached to NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

# ── Subnets ────────────────────────────────────────────────────────────────────

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnet_cidrs" {
  description = "List of CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

# ── Route Tables ───────────────────────────────────────────────────────────────

output "public_route_table_ids" {
  description = "List of public route table IDs"
  value       = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = aws_route_table.private[*].id
}

# ── Availability Zones ─────────────────────────────────────────────────────────

output "availability_zones" {
  description = "List of availability zones used"
  value       = aws_subnet.public[*].availability_zone
}

# ── Default Security Group ─────────────────────────────────────────────────────

output "default_security_group_id" {
  description = "The ID of the default security group (if managed)"
  value       = try(aws_default_security_group.this[0].id, null)
}
