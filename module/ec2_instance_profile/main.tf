resource "aws_iam_instance_profile" "falsh_app_profle" {
  name = var.name
  role = var.role_name
}
