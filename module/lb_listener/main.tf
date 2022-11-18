resource "aws_lb_listener" "lb_listener_http" {
   load_balancer_arn    = var.load_balancer_arn
   port                 = var.alb_listener_port
   protocol             = var.lb_listener_protocol
   default_action {
    target_group_arn = var.target_group_arn
    type             = "forward"
  }
}