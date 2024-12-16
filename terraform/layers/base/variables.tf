variable "project_name" {
    type = string
    description = "Name of project"
}
variable "environment" {
    type = string
    description = "Name of environment"
    default = "dev"
}

variable "vpc_cidr" { #Sets default CIDR range
    type = string
    description = "CIDR range"
    default = "10.0.0.0/16"
}
