data "aws_availability_zones" "available" {
    state = "available"
}

locals {
    azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "my-vpc"
    cidr = var.vpc_cidr

    azs             = local.azs #Instead of manually setting which azs, blocks are used to fetch all available az's
    private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k)] #cidrsubnets calculates subnet addess based on ip prefix of vpc_cidr
    public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k + 4)] #3 bits to the base block as there are 3 AZ's
                        
    enable_nat_gateway = true
    one_nat_gateway_per_az = var.environment == "dev" ? true : false
    single_nat_gateway = var.environment == "dev" ? true : false

    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

