output "vpc_arn" {
  value       = aws_vpc.main.arn
  description = "Amazon resource name for VPC"
}

output "vpc_tags" {
  value       = aws_vpc.main.tags_all
  description = "VPC tags"
}
