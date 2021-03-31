resource "aws_s3_bucket" "bucket1" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket1.id
  key    = "index.html"
  acl    = "private"  
  source = "./userdata/index.html"

  etag = filemd5("./userdata/index.html")

}