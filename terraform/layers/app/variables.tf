variable "project_name" {
    type = string
    description = "Name of project"
}
variable "environment" {
    type = string
    description = "Name of environment"
}
variable "Web_files_s3_bucket_name" {
  type = string
  default = "dev-ec2webfiles-s3-bucket"
}
