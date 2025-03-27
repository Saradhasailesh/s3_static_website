resource "random_string" "random" {
  length           = 8
  special          = false
  upper            = false 
}

resource "aws_s3_bucket" "My_bucket" {
  bucket        = "${var.bucket_name}-${random_string.random.result}"
  force_destroy = true

  tags = {
    Name        = "${var.bucket_name}-${random_string.random.result}"
  }
}

resource "aws_s3_bucket_website_configuration" "test_web_conf" {
  bucket = aws_s3_bucket.My_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_bucket_public_access_block" "test_public_access_block" {
  bucket = aws_s3_bucket.My_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "upload_object" {
  for_each     = fileset("html/", "*")
  bucket       = aws_s3_bucket.My_bucket.id
  key          = each.value
  source       = "html/${each.value}"
  etag         = filemd5("html/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_policy" "read_access_policy" {
  bucket = aws_s3_bucket.My_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.My_bucket.arn}",
        "${aws_s3_bucket.My_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}