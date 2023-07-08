data "aws_ami" "centos" {
  owners           = ["973714476881"]
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
}

data "aws_security_group" "allow-all" {
  name = "allow-all"
}

variable "components"{
  default = {
    frontend = {
      name          = "frontend"
      instance_type = "t3.micro"
    }
    catalogue = {
      name          = "catalogue"
      instance_type = "t3.micro"
    }
    mongodb = {
      name          = "mongodb"
      instance_type = "t3.micro"
    }
  }
}
resource "aws_instance" "frontend" {
  for_each = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance-type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = each.value["name"]
  }
}

/*resource "aws_route53_record" "frontend" {
  zone_id = "Z06720662E9995DMBFZQQ"
  name    = "frontend-dev.thumburuaditya.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}

resource "aws_instance" "mongodb" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "mongodb"
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = "Z06720662E9995DMBFZQQ"
  name    = "mongodb-dev.thumburuaditya.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.mongodb.private_ip]
}

resource "aws_instance" "catalogue" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "catalogue"
  }
}

resource "aws_route53_record" "catalogue" {
  zone_id = "Z06720662E9995DMBFZQQ"
  name    = "catalogue-dev.thumburuaditya.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.catalogue.private_ip]
} */
