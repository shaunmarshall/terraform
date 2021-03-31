# EIP 
resource "aws_eip" "app" {
  count = "${length(var.app_public_subnets_cidr)}"
  vpc = true
}

# VPC
resource "aws_vpc" "app_vpc" {
  cidr_block       = "${var.app_vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.deployment_name}_app_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  tags = {
    Name = "${var.deployment_name}_app_igw"
  }
}

# Nat Gateway
resource "aws_nat_gateway" "app_ngw" {
  count = "${length(var.app_private_subnets_cidr)}"
  subnet_id = "${element(aws_subnet.app_private.*.id,count.index)}"
  allocation_id = "${element(aws_eip.app.*.id,count.index)}"
  depends_on = [aws_internet_gateway.app_igw]
}



# Subnets : public
resource "aws_subnet" "app_public" {
  count = "${length(var.app_public_subnets_cidr)}"
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "${element(var.app_public_subnets_cidr,count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
  tags = {
    Name = "${var.deployment_name}_public_subnet-${count.index+1}"
  }
}

# Subnets : private
resource "aws_subnet" "app_private" {
  count = "${length(var.app_private_subnets_cidr)}"
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "${element(var.app_private_subnets_cidr,count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
  tags = {
    Name = "${var.deployment_name}_private_subnet-${count.index+1}"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "app_public_rt" {
  vpc_id = "${aws_vpc.app_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app_igw.id}"
  }
  tags = {
    Name = "publicRouteTable"
  }
}


# Route table association with public subnets
resource "aws_route_table_association" "app_public" {
  count = "${length(var.app_public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.app_public.*.id,count.index)}"
  route_table_id = "${aws_route_table.app_public_rt.id}"
}




 # Private Route Table

resource "aws_default_route_table" "private_route" {
  #count = "${length(var.app_private_subnets_cidr)}"
  default_route_table_id = "${aws_vpc.app_vpc.default_route_table_id}"

  route {
    #nat_gateway_id = "${aws_nat_gateway.app_ngw[count.index].id}"
    nat_gateway_id = aws_nat_gateway.app_ngw[0].id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "${var.deployment_name}-private-route-table"
  }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = "${length(var.app_private_subnets_cidr)}"
  #route_table_id = "${aws_default_route_table.private_route[count.index].id}"
  route_table_id = aws_default_route_table.private_route.id
  subnet_id      = aws_subnet.app_private[count.index].id
  depends_on     = ["aws_default_route_table.private_route", "aws_subnet.app_private"]
}











