
variable "aws_region" {
    description = "VPC AWS region" 
}

variable "aws_access_key" {
    type = string
    description = "AWS  user access key" 
}

variable "aws_secret_key" {
    type = string
    description = "AWS use secret key" 
}

variable "public_key" {
    description = "public key for ec2 access"
}

variable "sg_ingress_rules" {
  description = "Ingress security group rules"
  type        = map
}


variable "target_group_health_check" {
  description = "target group heath check"
  type        = map(string)
}