output "aws_network_interface" {
    value = aws_network_interface.Web-server-nic.id
}

output "security_groups" {
    value = aws_security_group.allow_web.id
}
