resource "random_string" "bucket_name" {
    length = 8
    upper = false
    special = false
  
}


resource "aws_s3_bucket" "boot_bucket" {
  bucket = "bootcamp-${random_string.bucket_name.result}" 
  tags = {
    Name        = "DevOps Bootcamp Bucket"
    Environment = "prod"
  }  
}
     
