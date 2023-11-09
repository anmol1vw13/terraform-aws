resource "aws_lb" "ec2_alb" {
  name               = "ec2-alb-2"
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


resource "aws_lb" "ec2_nlb" {
  name               = "ec2-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_group.id]
  subnets            = [for subnet in data.aws_subnet.ap-south-1-vpc : subnet.id]


  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

output "network_loadbalancer_dns" {
  value = aws_lb.ec2_alb.dns_name
}
