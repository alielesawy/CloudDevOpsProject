# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  # S3 Backend for state management
  backend "s3" {
    bucket         = "terraform-state-bucket-ivolve0123"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr    = "10.0.0.0/16" 
  subnet_cidr = "10.0.1.0/24"
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"
  
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.subnet_id
  instance_count    = 2
  instance_type     = "t2.micro"
  security_group_id = module.vpc.security_group_id
}