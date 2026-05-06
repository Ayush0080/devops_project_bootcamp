output "S3_bucket_name" {

  value = aws_s3_bucket.boot_bucket.bucket
}

output "S3_bucket_id" {
    value = aws_s3_bucket.boot_bucket.id
  
}

output "S3_bucket_region" {
  value = aws_s3_bucket.boot_bucket.region
}

output "S3_bucket_ARN" {
    value = aws_s3_bucket.boot_bucket.arn
  
}