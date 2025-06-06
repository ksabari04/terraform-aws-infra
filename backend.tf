terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-sabari"
    key            = "env/${terraform.workspace}/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
