

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "change_password_policy_attach" {
  group      = aws_iam_group.developers.name
  policy_arn = data.aws_iam_policy.userChangePassword.arn
}

resource "aws_iam_group_policy_attachment" "iam_read_only_attach" {
  group      = aws_iam_group.developers.name
  policy_arn = data.aws_iam_policy.iamReadOnlyAccess.arn
}
