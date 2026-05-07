resource "random_string" "bucket_name" {
  length  = 8
  upper   = false
  special = false

}


resource "aws_s3_bucket" "s3_backend" {
  bucket = "terraform-backend-${random_string.bucket_name.result}"
  tags = {
    Name        = "DevOps Bootcamp Bucket"
    Environment = var.environment_name
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "state_file_encryption" {
  bucket = aws_s3_bucket.s3_backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }


}

resource "aws_s3_bucket_versioning" "state_file_versioning" {
  bucket = aws_s3_bucket.s3_backend.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_public_access_block" "state_file_publice_access_block" {
  bucket                  = aws_s3_bucket.s3_backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}