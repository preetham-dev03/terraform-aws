resource "aws_instance" "common" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_groups
  root_block_device {
    delete_on_termination = var.delete_on_termination
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  iam_instance_profile = var.iam_instance_profile
  tags = var.tag
}