resource "aws_security_group" "webALBSG" {
  name        = "webALBSG"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.vpc-awsTC.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "TCP"
    cidr_blocks     = ["${var.vpc["appcidrBlock1"]}"]
  }

  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "TCP"
    cidr_blocks     = ["${var.vpc["appcidrBlock2"]}"]
  }

}

resource "aws_alb" "web_alb" {
    name = "webalb"
    internal = "false"
    load_balancer_type = "application"
    security_groups = ["${aws_security_group.webALBSG.id}"]
    subnets = ["${aws_subnet.web-subnet1.id}","${aws_subnet.web-subnet2.id}"]
}

resource "aws_lb_target_group" "web_alb_tg" {
    name = "webalbtg"
    port = 8080
    protocol = "HTTP"
    vpc_id = "${aws_vpc.vpc-awsTC.id}"
}

resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = "${aws_alb.web_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_alb_tg.arn}"
  }
}