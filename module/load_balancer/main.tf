resource "aws_lb" "common_lb" {
  name               = var.name
  load_balancer_type = var.load_balancer_type
  security_groups = var.security_groups
  dynamic "subnet_mapping" {
    for_each = var.lb_subnet_id
    content {
      subnet_id = subnet_mapping.value
    }
  }
  tags = var.tag
}