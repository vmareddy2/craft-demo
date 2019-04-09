resource "aws_security_group" "simpleAppSG" {
  name        = "simpleApp_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.vpc-awsTC.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["75.58.8.13/32"]
  }
  
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "simpleAppLC" {
  lifecycle {
    create_before_destroy = true
  }
  name_prefix   = "terraform-lc-"
  image_id = "ami-0524ac755aba24dd5"
  instance_type = "t2.micro"
  key_name = "vm2"
  associate_public_ip_address = "true"
  root_block_device {
  	delete_on_termination = "true"
  }
  user_data = "${file("tcUserData")}"
  security_groups = ["${aws_security_group.simpleAppSG.id}"]
}

resource "aws_autoscaling_group" "simpleAppAutoScale" {
	name = "simpleAppAutoScale"
	launch_configuration = "${aws_launch_configuration.simpleAppLC.name}"
	min_size = 2
	max_size = 5
	vpc_zone_identifier = ["${aws_subnet.app-subnet1.id}", "${aws_subnet.app-subnet2.id}"]
	lifecycle {
    	create_before_destroy = true
    }
    tags = [
        {
          key                 = "targetGroup"
          value               = "${aws_lb_target_group.web_alb_tg.arn}"
          propagate_at_launch = true
        },
    ]
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "web_tc_attach" {
  autoscaling_group_name = "${aws_autoscaling_group.simpleAppAutoScale.id}"
  alb_target_group_arn   = "${aws_lb_target_group.web_alb_tg.arn}"
}
