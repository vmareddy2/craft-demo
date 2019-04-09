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

resource "aws_iam_role" "tc-ec2-role" {
    name = "tc-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "test"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "tc-ec2-policy-document" {
    statement {
            sid = "VisualEditor0"
            effect = "Allow"
            actions = ["elasticloadbalancing:RegisterTargets"]
            resources = ["${aws_lb_target_group.web_alb_tg.arn}"]
        }
}

data "aws_iam_policy_document" "tc-ec2-policy2-document" {
    statement {
            sid = "VisualEditor1"
            effect = "Allow"
            actions = ["ec2:DescribeInstances"]
            resources = ["*"]
        }
}

resource "aws_iam_role_policy" "tc-ec2-policy" {
  name   = "tc-ec2-policy"
  role = "${aws_iam_role.tc-ec2-role.id}"
  policy = "${data.aws_iam_policy_document.tc-ec2-policy-document.json}"
}

resource "aws_iam_role_policy" "tc-ec2-policy2" {
  name   = "tc-ec2-policy2"
  role = "${aws_iam_role.tc-ec2-role.id}"
  policy = "${data.aws_iam_policy_document.tc-ec2-policy2-document.json}"
}

resource "aws_iam_instance_profile" "tc-ec2_profile" {
  name = "tc-ec2_profile"
  role = "${aws_iam_role.tc-ec2-role.id}"
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
  iam_instance_profile = "${aws_iam_instance_profile.tc-ec2_profile.name}"
}

resource "aws_autoscaling_group" "simpleAppAutoScale" {
	name = "simpleAppAutoScale"
	launch_configuration = "${aws_launch_configuration.simpleAppLC.name}"
	min_size = 1
	max_size = 1
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

