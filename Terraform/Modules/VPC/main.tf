resource "aws_vpc" "VPC" {
  cidr_block = var.VPC_CIDR
  tags = {
    Name       = var.VPC_Name
    Deployment = "Terraform"
  }
}

resource "aws_subnet" "PubSub1" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.PubSub1_CIDR
  availability_zone       = var.PubSub1_AZ
  map_public_ip_on_launch = true
  tags = {
    Name       = "Public_Subnet1"
    Deployment = "Terraform"
  }
}
resource "aws_subnet" "PubSub2" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.PubSub2_CIDR
  availability_zone       = var.PubSub2_AZ
  map_public_ip_on_launch = true
  tags = {
    Name       = "Public_Subnet2"
    Deployment = "Terraform"
  }
}
resource "aws_subnet" "PrivSub1" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PrivSub1_CIDR
  availability_zone = var.PrivSub1_AZ
  tags = {
    Name       = "Private_Subnet1"
    Deployment = "Terraform"
  }
}
resource "aws_subnet" "PrivSub2" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PrivSub2_CIDR
  availability_zone = var.PrivSub2_AZ
  tags = {
    Name       = "Private_Subnet2"
    Deployment = "Terraform"
  }
}
resource "aws_subnet" "PrivSub3" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PrivSub3_CIDR
  availability_zone = var.PrivSub3_AZ
  tags = {
    Name       = "Private_Subnet3"
    Deployment = "Terraform"
  }
}
resource "aws_subnet" "PrivSub4" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PrivSub4_CIDR
  availability_zone = var.PrivSub4_AZ
  tags = {
    Name       = "Private_Subnet4"
    Deployment = "Terraform"
  }
}


resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name       = "Terraform IGW"
    Deployment = "Terraform"
  }
}
resource "aws_eip" "NatEIP" {
  domain = "vpc"
}
resource "aws_nat_gateway" "NatGW" {
  subnet_id     = aws_subnet.PubSub2.id
  allocation_id = aws_eip.NatEIP.id
  tags = {
    Name       = "Terraform NAT"
    Deployment = "Terraform"
  }
  depends_on = [aws_internet_gateway.IGW]
}


resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name       = "PublicRT"
    Deployment = "Terraform"
  }
}
resource "aws_route_table_association" "Pub1_Association" {
  subnet_id      = aws_subnet.PubSub1.id
  route_table_id = aws_route_table.PubRT.id
}
resource "aws_route_table_association" "Pub2_Association" {
  subnet_id      = aws_subnet.PubSub2.id
  route_table_id = aws_route_table.PubRT.id
}


resource "aws_route_table" "PrivRT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NatGW.id
  }
  tags = {
    Name       = "PrivateRT"
    Deployment = "Terraform"
  }
}
resource "aws_route_table_association" "Priv1_Association" {
  subnet_id      = aws_subnet.PrivSub1.id
  route_table_id = aws_route_table.PrivRT.id
}
resource "aws_route_table_association" "Priv2_Association" {
  subnet_id      = aws_subnet.PrivSub2.id
  route_table_id = aws_route_table.PrivRT.id
}
resource "aws_route_table_association" "Priv3_Association" {
  subnet_id      = aws_subnet.PrivSub3.id
  route_table_id = aws_route_table.PrivRT.id
}
resource "aws_route_table_association" "Priv4_Association" {
  subnet_id      = aws_subnet.PrivSub4.id
  route_table_id = aws_route_table.PrivRT.id
}