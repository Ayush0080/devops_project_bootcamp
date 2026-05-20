module "vpc" {
source  = "./VPC"
environment_name = var.environment_name
vpc_cidr = var.vpc_cidr
subnet_newbits = var.subnet_newbits
tags = var.tags
}