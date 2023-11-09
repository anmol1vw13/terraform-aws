variable "vpc_id" {
  default = "vpc-0adc54db253f9c7c4"
}


variable "ec2_launch_template" {
  type    = string
  default = <<EOF
#!/bin/bash
sudo su
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1> Hello world form $(hostname -f)</h1>" > /var/www/html/index.html
EOF
}
