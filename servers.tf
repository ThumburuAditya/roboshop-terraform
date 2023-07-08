data "aws_ami" "centos" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "frontend"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "mongodb"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "catalogue"
  }
}

