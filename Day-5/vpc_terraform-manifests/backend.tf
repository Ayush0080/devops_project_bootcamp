terraform {
  backend "s3" {
    bucket       = "terraform-backend-0ongxqpm"
    key          = "boot_camp/vpc/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true


  }
}