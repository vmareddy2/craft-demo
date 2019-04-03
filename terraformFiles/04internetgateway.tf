resource "aws_internet_gateway" "igw-1" {
	vpc_id = "${aws_vpc.vpc-awsTC.id}"
}
