module "Web_files_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.environment}-ec2webfiles-s3-bucket"

  versioning = {
    enabled = true
  }
}