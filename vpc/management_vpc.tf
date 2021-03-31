# VPC
resource "aws_vpc" "management_vpc" {
  cidr_block       = "${var.management_vpc_cidr}"
  enable_dns_hostnames  = true
  tags = {
    Name = "${var.deployment_name}_management_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "management_igw" {
  vpc_id = "${aws_vpc.management_vpc.id}"
  tags = {
    Name = "${var.deployment_name}_management_igw"
  }
}


# Subnets : public
resource "aws_subnet" "management_public" {
  vpc_id = "${aws_vpc.management_vpc.id}"
  cidr_block = "${var.management_public_subnets_cidr}"
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.deployment_name}_management_public_subnet"
  }
}


# Route table: attach Internet Gateway 
resource "aws_route_table" "management_public_rt" {
  vpc_id = "${aws_vpc.management_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.management_igw.id}"
  }
  tags = {
    Name = "publicRouteTable"
  }
}


# Route table association with public subnets
resource "aws_route_table_association" "management_public" {
  subnet_id      = "${aws_subnet.management_public.id}"
  route_table_id = "${aws_route_table.management_public_rt.id}"
}










