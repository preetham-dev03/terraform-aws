variable "vpc_id"  {
    description = " variable for VPC id "
}
variable "subnet_cidr_block" {
   description = " variable for subnet cidr block " 
}

variable "subnet_availability_zone" {
   description = " variable for subnet availability zone " 
}

variable "public_ip_enabled" {
   description = " set the public ip auto assignment for instance launced in the subnet " 
}
