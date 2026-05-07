output "S3_bucket_name" {

  value = aws_s3_bucket.s3_backend.bucket
}

output "S3_bucket_id" {
  value = aws_s3_bucket.s3_backend.id

}

output "S3_bucket_region" {
  value = aws_s3_bucket.s3_backend.region
}

output "S3_bucket_ARN" {
  value = aws_s3_bucket.s3_backend.arn

}