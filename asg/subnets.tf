data "aws_subnets" "ap-south-1-vpc" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "ap-south-1-vpc" {
  for_each = toset(data.aws_subnets.ap-south-1-vpc.ids)
  id       = each.value
}
