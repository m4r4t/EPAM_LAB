resource "aws_vpc" "master" {
  provider             = aws.region-master-yalk
  cidr_block           = var.master_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master vpc"
  }
}

data "aws_availability_zones" "azs" {
  provider = aws.region-master-yalk
  state    = "available"
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw-master" {
  provider = aws.region-master-yalk
  vpc_id   = aws_vpc.master.id
  tags = {
    Name = "IGW-master"
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  provider   = aws.region-master-yalk
  vpc        = true
  depends_on = [aws_internet_gateway.igw-master]
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  provider      = aws.region-master-yalk
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.master_public_subnets.*.id, 0)
  depends_on    = [aws_internet_gateway.igw-master]
  tags = {
    Name = "nat-master"
  }
}



resource "aws_subnet" "master_public_subnets" {
  provider                = aws.region-master-yalk
  count                   = length(var.master_public_subnets)
  vpc_id                  = aws_vpc.master.id
  cidr_block              = var.master_public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "master_vpc_public_subnet_${count.index}_${data.aws_availability_zones.azs.names[count.index]}"
  }
}

resource "aws_subnet" "master_private_subnets" {
  provider                = aws.region-master-yalk
  count                   = length(var.master_private_subnets)
  vpc_id                  = aws_vpc.master.id
  cidr_block              = var.master_private_subnets[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "master_vpc_private_subnet_${count.index}_${data.aws_availability_zones.azs.names[count.index]}"
  }
}

resource "aws_route_table" "private" {
  provider = aws.region-master-yalk
  vpc_id   = aws_vpc.master.id
  tags = {
    Name = "Private-RT"
  }
}

resource "aws_route_table" "public" {
  provider = aws.region-master-yalk
  vpc_id   = aws_vpc.master.id
  tags = {
    Name = "Public RT"
  }
}

resource "aws_route" "public_igw" {
  provider               = aws.region-master-yalk
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-master.id
}

resource "aws_route" "private_nat_gw" {
  provider               = aws.region-master-yalk
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  provider       = aws.region-master-yalk
  count          = length(var.master_public_subnets)
  subnet_id      = element(aws_subnet.master_public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  provider       = aws.region-master-yalk
  count          = length(var.master_private_subnets)
  subnet_id      = element(aws_subnet.master_private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  provider    = aws.region-master-yalk
  name        = "master-vpc-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.master.id
  depends_on  = [aws_vpc.master]
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    self      = false
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = false
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Master-SG-Default"
  }
}