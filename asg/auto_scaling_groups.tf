resource "aws_autoscaling_group" "ec2-asg" {
  name                      = "ec2-asg"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  availability_zones        = ["ap-south-1a", "ap-south-1b"]
  launch_template {
    id      = aws_launch_template.ec2-template.id
    version = aws_launch_template.ec2-template.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
    }
    triggers = ["launch_template"]
  }
}

resource "aws_autoscaling_attachment" "ec2-asg" {
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.id
  lb_target_group_arn    = aws_lb_target_group.ec2-alb-target-group.arn
}

resource "aws_launch_template" "ec2-template" {
  name_prefix          = "asg"
  instance_type        = "t2.nano"
  image_id             = "ami-06791f9213cbb608b"
  key_name             = "terraform-key"
  user_data            = base64encode(var.ec2_launch_template)
  security_group_names = [aws_security_group.ec2_group.name]
}

resource "aws_autoscaling_policy" "ec2-asg-simple-scaling-up" {
  name                   = "ec2-asg-simple-scaling-up"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
}



resource "aws_autoscaling_policy" "ec2-asg-simple-scaling-down" {
  name                   = "ec2-asg-simple-scaling-down"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
}


resource "aws_cloudwatch_metric_alarm" "ec2-asg-cpu-up" {
  alarm_name = "ec2 asg alarm up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPU Utilization"
  namespace = "AWS/EC2"
  period = "30"
  statistic = "Average"
  threshold = "10"
  
  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
  }

  alarm_description = "Monitor Ec2 instance CPU Utilization"
  alarm_actions = [aws_autoscaling_policy.ec2-asg-simple-scaling-up.arn]
}

resource "aws_cloudwatch_metric_alarm" "ec2-asg-cpu-down" {
  alarm_name = "ec2 asg alarm down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPU Utilization"
  namespace = "AWS/EC2"
  period = "30"
  statistic = "Average"
  threshold = "5"
  
  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
  }

  alarm_description = "Monitor Ec2 instance CPU Utilization"
  alarm_actions = [aws_autoscaling_policy.ec2-asg-simple-scaling-down.arn]
}