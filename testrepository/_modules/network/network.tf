# Create VPC
resource "aws_vpc" "VPC-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Production"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC-1.id
}

# Create route table
resource "aws_route_table" "Prod-route-table" {
  vpc_id = aws_vpc.VPC-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

# Create Subnet
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.VPC-1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = var.subnet1-tag
  }
}

# Associate route table to subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.Prod-route-table.id
}


# Create security group
resource "aws_security_group" "allow_web" {
  name        = "Allow web traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.VPC-1.id

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
  name ="Allow Web"
}
}

# Create network interface
resource "aws_network_interface" "Web-server-nic" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

# Assign Elastic IP
resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.Web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}