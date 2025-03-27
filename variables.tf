variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-default-bucket"
}

variable "region" {
  description = "AWS region for deployment"
  type        = string
}
