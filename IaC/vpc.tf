# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}


# Subnets
resource "aws_subnet" "main-public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "main-public-1"
  }
}

# Subnets
resource "aws_subnet" "main-private-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "main-public-1"
  }
}


# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

#NAT gateway
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.NAT-EIP.id
  subnet_id     = aws_subnet.main-public-1.id

  tags = {
    Name = "gw NAT"
  }
}

#bastion host
resource "aws_instance" "bastion-host" {
  ami        = var.AMI
  instance_type   = var.INSTANCE_TYPE
  disable_api_termination = false
  subnet_id     = aws_subnet.main-public-1.id
  security_groups = [aws_security_group.bastion-SG.id]
  tags = {
    Name = "bastionHost"
  }
}

resource "aws_eip" "bastion-host-eip" {
  instance = aws_instance.bastion-host.id
  vpc = true
}

# EIP NAT
resource "aws_eip" "NAT-EIP" {
  vpc      = true
}

# route table public
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "main-public-1"
  }
}

# route table private
resource "aws_route_table" "custom-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = "custom-private-1"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
}
# route associations private
resource "aws_route_table_association" "main-private-1-a" {
  subnet_id      = aws_subnet.main-private-1.id
  route_table_id = aws_route_table.custom-private.id
}

