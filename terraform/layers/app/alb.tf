data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket = "956729386419-eu-west-2-grad-lab-1-tf-state"
    key    = "state/dev/base/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "aws_vpc" "vpc"{
    filter {
        name    = "tag:Name"
        values  = ["${var.environment}-vpc"]
    }
}

data "aws_subnets" "vpc_public_subnets"{
    filter {
        name    = "vpc-id"
        values  = [data.aws_vpc.vpc]
    }
    filter {
      name = "tag:Name"
      values = ["${var.environment}-vpc-public-*"]
    }
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.12.0"

  name    = "${var.environment}-alb"
  vpc_id  = data.aws_vpc.vpc
  subnets = data.aws_subnets.vpc_public_subnets

  # Assign the security group to the ALB
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  target_groups = [
    {
      name_prefix      = "web-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        path                = "/"
        port                = 80
        timeout             = 15
        interval            = 180
        matcher             = "200"
        unhealthy_threshold = 5
      }
    }
  ]

  listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Dev"
  }
}