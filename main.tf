resource "oktaasa_project" "asa_project" {
  project_name = var.oktaasa_project
}

resource "oktaasa_enrollment_token" "enrollment_token" {
  project_name = oktaasa_project.asa_project.project_name
  description  = "ASA enrollment token for project"
}

resource "oktaasa_create_group" "group_name" {
  name = "ops-team"
}

resource "oktaasa_assign_group" "group-assignment" {                                                                      project_name  = oktaasa_project.asa_project.project_name
  group_name    = oktaasa_create_group.group_name.name
  server_access = true
  server_admin  = true
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Environment = var.environment_tag
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone
  tags = {
    Environment = var.environment_tag
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_route_table_association" "route_table_subnet" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name   = "sg_ssh"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  user_data              = templatefile("sftd-userdata.sh", { enrollment_token = oktaasa_enrollment_token.enrollment_token.token_value})
  tags = {
    Environment = var.environment_tag
  }
}