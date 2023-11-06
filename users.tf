locals {
  users_map = { for user in var.users : user.name => user }
}

locals {
  developer_users = [
    for user in var.users :
    user.name if contains(user.groups, "developer")
  ]
}

resource "aws_iam_user" "all_users" {
  for_each = local.users_map
  name     = each.value.name
  path     = "/"
  tags = {
    email : each.value.email
  }
}

resource "aws_iam_user_login_profile" "profiles" {
  for_each                = local.users_map
  user                    = aws_iam_user.all_users[each.key].name
  password_reset_required = true
  password_length         = 9

  lifecycle {
    ignore_changes = [password, password_reset_required, password_length]
  }
}

resource "aws_iam_group_membership" "developer_membership" {
  depends_on = [aws_iam_user.all_users, aws_iam_group.developers]
  name       = "developer_membership"
  users      = local.developer_users
  group      = aws_iam_group.developers.name
}


output "username_passwords" {
  value = { for profile in aws_iam_user_login_profile.profiles : profile.user => profile.password }
}
