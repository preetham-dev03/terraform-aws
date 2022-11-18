resource "aws_lb_target_group_attachment" "tg_attachment_test" {
    target_group_arn = var.target_group_arn
    target_id        = var.instance_id
    port             = var.port
}