# Define IAM Role and Instance Profile
resource "aws_iam_role" "launchtemplateRole" {
  name = "launchtemplateRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "launchtemplateRole_attachment" {
  role       = aws_iam_role.launchtemplateRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "EC2_instance_profile" {
  name = "EC2_instance_profile"
  role = aws_iam_role.launchtemplateRole.name
}

# launch_template.tf
resource "aws_launch_template" "web_server" {
  name_prefix   = "web-server-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

 iam_instance_profile {
    name = aws_iam_instance_profile.EC2_instance_profile.name

  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [module.network.security_groups]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server"
    }
  }
}
