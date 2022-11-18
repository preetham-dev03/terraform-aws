variable "name" {
    description = "targetgroup name"    
}

variable "target_type"  {
    description = " target group type "
    default = "instance"
}

variable "target_group_port" {
    description = "target_group_port"   
    default = "8000" 
}

variable "taget_group_protocol"  {
    description = " taget_group_protocol"
    default = "HTTP"
}

variable "vpc_id" {
    description = "vpc id "    
}

variable "health_check"  {
    description = " target group heath check "
    type = map(string)
}
