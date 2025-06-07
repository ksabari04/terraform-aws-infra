provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "envi" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "example-${terraform.workspace}"
  }
}
