data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket = "956729386419-eu-west-2-grad-lab-1-tf-state"
    key    = "state/dev/base/terraform.tfstate"
    region = "eu-west-2"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.terraform_remote_state.base.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP web traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS web traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "alb-sg"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name    = "${var.environment}-alb"
  vpc_id  = data.terraform_remote_state.base.outputs.vpc_id
  subnets = data.terraform_remote_state.base.outputs.public_subnets

  # Assign the security group to the ALB
  security_groups = [aws_security_group.alb.id]

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

  http_tcp_listeners = [
    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Dev"
  }
}