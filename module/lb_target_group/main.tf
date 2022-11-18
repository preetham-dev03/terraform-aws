resource "aws_lb_target_group" "lb_target_group" {
   name               = var.name
   target_type        = var.target_type
   port               = var.target_group_port
   protocol           = var.taget_group_protocol
   vpc_id             = var.vpc_id
   health_check {
      healthy_threshold   = var.health_check["healthy_threshold"]
      interval            = var.health_check["interval"]
      unhealthy_threshold = var.health_check["unhealthy_threshold"]
      timeout             = var.health_check["timeout"]
      path                = var.health_check["path"]
      port                = var.health_check["port"]
  }
}