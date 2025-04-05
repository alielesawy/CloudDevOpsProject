# modules/ec2/variables.tf
variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "security_group_id" {
  type = string
}