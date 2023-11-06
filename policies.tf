data "aws_iam_policy" "userChangePassword" {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}


data "aws_iam_policy" "iamReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}
