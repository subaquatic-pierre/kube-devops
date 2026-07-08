# ---------------------------------------------------------------------------------------------------------------------
# VPC MODULE - Input Variables
# ---------------------------------------------------------------------------------------------------------------------

# ── VPC Configuration ──────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC. Defaults to <environment>-vpc if not set"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod) used for tagging and naming"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ── DNS ────────────────────────────────────────────────────────────────────────

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

# ── Availability Zones & Subnets ───────────────────────────────────────────────

variable "availability_zones" {
  description = "List of availability zones to use (e.g. [\"us-east-2a\", \"us-east-2b\"])"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "az_count" {
  description = "Number of availability zones to use. Must not exceed the length of availability_zones"
  type        = number
  default     = 2
}

variable "public_subnet_newbits" {
  description = "Additional bits for public subnet CIDR calculation (e.g. 8 gives a /24 from a /16)"
  type        = number
  default     = 8
}

variable "private_subnet_newbits" {
  description = "Additional bits for private subnet CIDR calculation (e.g. 8 gives a /24 from a /16)"
  type        = number
  default     = 8
}

variable "public_subnet_cidrs" {
  description = "Explicit public subnet CIDR blocks. Overrides auto-calculation if set"
  type        = list(string)
  default     = null
}

variable "private_subnet_cidrs" {
  description = "Explicit private subnet CIDR blocks. Overrides auto-calculation if set"
  type        = list(string)
  default     = null
}

variable "map_public_ip_on_launch" {
  description = "Assign a public IP to instances launched in public subnets"
  type        = bool
  default     = true
}

# ── Feature toggles ────────────────────────────────────────────────────────────

variable "create_igw" {
  description = "Create an Internet Gateway"
  type        = bool
  default     = true
}

variable "create_public_subnets" {
  description = "Create public subnets"
  type        = bool
  default     = true
}

variable "create_private_subnets" {
  description = "Create private subnets"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Create NAT Gateway(s) for private subnets outbound traffic"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (cost saving). Only meaningful when create_nat_gateway is true"
  type        = bool
  default     = true
}

variable "manage_default_security_group" {
  description = "Manage the VPC default security group"
  type        = bool
  default     = false
}

# ── VPC Flow Logs ──────────────────────────────────────────────────────────────

variable "enable_flow_logs" {
  description = "Enable VPC flow logs"
  type        = bool
  default     = false
}

variable "flow_logs_traffic_type" {
  description = "Traffic type for flow logs: ACCEPT, REJECT, or ALL"
  type        = string
  default     = "ALL"
}

variable "flow_logs_log_group_name" {
  description = "CloudWatch log group name for flow logs"
  type        = string
  default     = null
}

variable "flow_logs_iam_role_arn" {
  description = "IAM role ARN for flow logs delivery"
  type        = string
  default     = null
}
