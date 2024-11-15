terraform {
  required_version = "~> 1.9.8"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Defines default tags for resources
provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Author      = "Matthew-Blatherwick"
    }
  }
}