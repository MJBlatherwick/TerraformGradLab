resource "aws_s3_object" "object" {
  bucket = var.Web_files_s3_bucket_name
  key    = "index.html"
  source = "/Users/mattblatherwick/LABS/TerraformGradLab/src/lab1/src/index.html"
}