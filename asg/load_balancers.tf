resource "aws_lb" "ec2_alb" {
  name               = "ec2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_group.id]
  subnets            = [for subnet in data.aws_subnet.ap-south-1-vpc : subnet.id]


  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

output "application_loadbalancer_dns" {
  value = aws_lb.ec2_alb.dns_name
}

resource "aws_lb_target_group" "ec2-alb-target-group" {
  name     = "ec2-alb-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id


  stickiness {
    enabled = true
    type    = "lb_cookie"
  }
}

resource "aws_lb_listener" "alb_front_end" {
  load_balancer_arn = aws_lb.ec2_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-alb-target-group.arn
  }
}