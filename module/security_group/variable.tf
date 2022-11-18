variable "sg_ingress_rules" {
  description = "Ingress security group rules"
  type        = map
}

variable "name" {
  description = "name of security group "
  
}

variable "vpc_id" {
  description = "vpc id"
  
}

variable "tag" {
    description = "tag"    
}