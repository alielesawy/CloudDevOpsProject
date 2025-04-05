# modules/vpc/variables.tf
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for subnet"
}