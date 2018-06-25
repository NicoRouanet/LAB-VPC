terraform {
  backend "s3" {
    bucket = "terraform-lab123"
    key    = "terraform_template_vpc"
	region = "us-east-1"
  }
}