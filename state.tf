terraform {
  backend "s3" {
    bucket = "terraform-aditya"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
