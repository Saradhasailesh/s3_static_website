output "bucket_arn" {
  value = aws_s3_bucket.My_bucket.arn
}

output "bucket_url" {
  value = "https://${aws_s3_bucket.My_bucket.bucket}.s3.amazonaws.com"
}

output "s3_bucket_id" {
  value = aws_s3_bucket_website_configuration.test_web_conf.website_endpoint
}