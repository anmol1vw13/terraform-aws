resource "aws_instance" "ec2" {
  instance_type        = "t2.micro"
  ami                  = "ami-06791f9213cbb608b"
  key_name             = "terraform-key"
  iam_instance_profile = data.aws_iam_instance_profile.demo-role.name
  security_groups      = [aws_security_group.ec2_group.name]
  count                = 2
  user_data            = <<EOF
#!/bin/bash
sudo su
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1> Hello world form $(hostname -f)</h1>" > /var/www/html/index.html
EOF
}

data "aws_iam_instance_profile" "demo-role" {
  name = "demo-role"
}



resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ec2_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-target-group.arn
  }
}



resource "aws_lb_target_group" "ec2-target-group" {
  name     = "ec2-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


locals {
  instance-ids = {
    for k, v in aws_instance.ec2 : v.id => v
  }
}

resource "aws_lb_target_group_attachment" "ec2-group-attach" {
  # covert a list of instance objects to a map with instance ID as the key, and an instance
  # object as the value.
  depends_on = [aws_instance.ec2]

  count = length(aws_instance.ec2)


  target_group_arn = aws_lb_target_group.ec2-target-group.arn
  target_id        = aws_instance.ec2[count.index].id
  port             = 80
}


output "ip" {
  value = aws_instance.ec2[*].public_ip
}
