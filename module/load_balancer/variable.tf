variable "lb_subnet_id" {
  description = "list of subnet id to be mapped "
  type        = map
}

variable "name" {
  description = "name of loadbalancer  "
  
}

variable "security_groups" {
  description = "security_groups of the load balancer"
  
}

variable "tag" {
    description = "tag"    
}


variable "load_balancer_type" {
    description = "load_balancer  type"    
}