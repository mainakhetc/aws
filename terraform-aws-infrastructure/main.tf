# ----------------------------------------
# VPC
# ----------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


# ----------------------------------------
# Public Subnet
# ----------------------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}


# ----------------------------------------
# Private Subnet
# ----------------------------------------

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}


# ----------------------------------------
# Internet Gateway
# ----------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}


# ----------------------------------------
# Public Route Table
# ----------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}


# ----------------------------------------
# Public Route to Internet Gateway
# ----------------------------------------

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}


# ----------------------------------------
# Public Route Table Association
# ----------------------------------------

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# ----------------------------------------
# Private Route Table
# ----------------------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}


# ----------------------------------------
# Private Route Table Association
# ----------------------------------------

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# ----------------------------------------
# EC2 Security Group
# ----------------------------------------

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for Terraform web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}


# ----------------------------------------
# Allow HTTP
# ----------------------------------------

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP web traffic"
}


# ----------------------------------------
# Allow SSH from Administrator IP
# ----------------------------------------

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = var.admin_ip
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "Allow SSH from administrator IP"
}


# ----------------------------------------
# Allow All Outbound Traffic
# ----------------------------------------

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"
}

# ----------------------------------------
# IAM Role for EC2
# ----------------------------------------

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

# ----------------------------------------
# IAM Instance Profile
# ----------------------------------------

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2.name
}

# ----------------------------------------
# EC2 Web Server
# ----------------------------------------

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install -y httpd

              systemctl enable httpd
              systemctl start httpd

              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                <title>Terraform AWS Web Server</title>
              </head>
              <body>
                <h1>Terraform AWS Infrastructure</h1>
                <p>This web server was provisioned using Terraform.</p>
                <p>EC2 + VPC + Security Group + IAM</p>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name = "${var.project_name}-web-server"
  }
}
