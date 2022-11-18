variable "ami_id" {
    description = "ami_id"    
}

variable "instance_type" {
    description = "ec2 instance_type" 
    default = "t2.micro"  
}

variable "key_name" {
    description = "ec2 key pair name"    
}

variable "subnet_id" {
    description = "subnet_id  for ec2 instance"    
}


variable "security_groups" {
    description = "ec2 security_groups"    
}

variable "delete_on_termination" {
    description = "delete_on_termination flag" 
    default = "true"
     
}


variable "volume_size" {
    description = "volume_size  in GB "
    default = 50
    type = number    
}

variable "volume_type" {
    description = "volume_type for ec2 instance" 
    default = "gp2"   
}


variable "tag" {
    description = "tag"    
}

variable "iam_instance_profile" {
    description = "instance profile to be attached"
}