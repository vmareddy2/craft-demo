resource "aws_vpc" "vpc-awsTC" {
  cidr_block = "10.0.0.0/16"
  tags = {
      name = "vpc-1"
  }
}
