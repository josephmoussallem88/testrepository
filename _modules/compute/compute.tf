module "network" {
  source = "../network"
  availability_zone = var.availability_zone
  subnet1-tag = var.subnet1-tag  
}

# Create Ubuntu Server
resource "aws_instance" "web-server-instance" {

  ami               = "ami-00ac45f3035ff009e"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-3a"
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    #network_interface_id = aws_network_interface.Web-server-nic.id
    network_interface_id = module.network.aws_network_interface
  }
  user_data = <<-EOF
       #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo systemctl start apache2
        echo "Deploy a web server on aws" | sudo tee /var/www/html/index.html
        EOF

  tags = {
    name = "Web-Server-Terra"
  }
}

