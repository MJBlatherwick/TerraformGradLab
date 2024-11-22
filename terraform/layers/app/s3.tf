data "aws_s3_bucket" "Web_files_s3_bucket" {
  bucket = "${var.environment}-ec2webfiles-s3-bucket"
}

resource "aws_s3_object" "object" {
  bucket = data.aws_s3_bucket.Web_files_s3_bucket.id
  key    = "index.html"
  source = "./src/index.html"
}