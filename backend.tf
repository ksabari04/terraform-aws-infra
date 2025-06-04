terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-sabari"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}