terraform {
  backend "s3" {
    bucket = "terraform-aditya"
    key    = "roboshop/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
