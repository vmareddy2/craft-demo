resource "aws_vpc" "vpc-awsTC" {
  cidr_block = "${var.vpc["cidrBlock"]}"
  tags = {
      Name = "${var.vpc["name"]}"
  }
}

resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.vpc-awsTC.id}"
	tags = {
		Name = "${var.vpc["name"]}-igw"
	}
}

resource "aws_route_table" "public-routetable" {
  vpc_id = "${aws_vpc.vpc-awsTC.id}"

  route {
    gateway_id = "${aws_internet_gateway.igw.id}"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "${var.vpc["name"]}-public-rt"
  }
}

resource "aws_subnet" "app-subnet1" {
  vpc_id = "${aws_vpc.vpc-awsTC.id}"
  cidr_block = "${var.vpc["appcidrBlock1"]}"
  tags = {
  	Name =  "${var.vpc["name"]}-app-subnet1"
  }
  availability_zone="${var.availability_zone1}"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "app-subnet2" {
  vpc_id = "${aws_vpc.vpc-awsTC.id}"
  cidr_block = "${var.vpc["appcidrBlock2"]}"
  tags = {
  	Name =  "${var.vpc["name"]}-app-subnet2"
  }
  availability_zone="${var.availability_zone2}"
  map_public_ip_on_launch = "true"
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = "${aws_subnet.app-subnet1.id}"
  route_table_id = "${aws_route_table.public-routetable.id}"
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = "${aws_subnet.app-subnet2.id}"
  route_table_id = "${aws_route_table.public-routetable.id}"
}


