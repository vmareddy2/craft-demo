resource "aws_subnet" "subnet-1" {
  vpc_id = "${aws_vpc.vpc-awsTC.id}"
  cidr_block = "10.0.0.0/24"
}
