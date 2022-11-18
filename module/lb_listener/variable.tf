variable "load_balancer_arn" {
    description = "load_balancer_arn"    
}


variable "alb_listener_port" {
    description = "alb_listener_port"   
    default = "8000" 
}

variable "lb_listener_protocol"  {
    description = " lb_listener_protocol"
    default = "HTTP"
}

variable "target_group_arn" {
    description = "target_group_arn "    
}
