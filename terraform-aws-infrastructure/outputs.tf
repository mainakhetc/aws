output "vpc_id" {
  description = "ID of the Terraform VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "web_security_group_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.web.id
}

output "ec2_instance_id" {
  description = "ID of the EC2 web server"
  value       = aws_instance.web.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 web server"
  value       = aws_instance.web.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 web server"
  value       = aws_instance.web.public_dns
}

output "web_url" {
  description = "URL of the Terraform web server"
  value       = "http://${aws_instance.web.public_ip}"
}

output "ec2_iam_role" {
  description = "IAM role attached to the EC2 instance"
  value       = aws_iam_role.ec2.name
}
