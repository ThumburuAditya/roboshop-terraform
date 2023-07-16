resource "aws_instance" "instance" {
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = local.name
  }
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instance, aws_route53_record.records]
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }
    inline = [
      app_type == db ? local.db_commands : local.app_commands
    ]
  }
}
resource "aws_route53_record" "records" {
  zone_id = "Z06720662E9995DMBFZQQ"
  name    = "${var.component_name}-dev.thumburuaditya.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance .private_ip]
}

resource "aws_iam_role" "role" {
  name = "${var.component_name}- ${var.env}-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "ssm_ps_policy" {
  name = "${var.component_name}- ${var.env}-role-ssm-ps-policy"
  role = aws_iam_role.role.id
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "ssm:GetParameterHistory",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource": "arn:aws:ssm:us-east-1:363684552706:parameter/${var.env}.${var.component_name}.*"
        },
        {
          "Sid": "VisualEditor1",
          "Effect": "Allow",
          "Action": "ssm:DescribeParameters",
          "Resource": "*"
        }
      ]
    }
  )
}