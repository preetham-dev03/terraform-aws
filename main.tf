terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  tag = {
    Name = "tech-challenge"
  }
  lb_subnet_id = {
    subnet_a = module.public_subnet_easta.aws_subnet_id
    subnet_b = module.public_subnet_eastb.aws_subnet_id
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "vpc" {
    source = "./module/vpc"
    vpc_cidr_block = "10.1.0.0/16"
    tag = local.tag
}


module "public_subnet_easta" {
  source = "./module/subnet"
  vpc_id = module.vpc.aws_vpc_id
  subnet_cidr_block = "10.1.21.0/24"
  subnet_availability_zone = "us-east-2a"
  public_ip_enabled = true
}

module "public_subnet_eastb" {
  source = "./module/subnet"
  vpc_id = module.vpc.aws_vpc_id
  subnet_cidr_block = "10.1.20.0/24"
  subnet_availability_zone = "us-east-2b"
  public_ip_enabled = true
}



module "aws_igw" {
  source = "./module/igw"
  vpc_id = module.vpc.aws_vpc_id
  tag = local.tag
}


module "public_route_table" {
  source = "./module/route_table"
  vpc_id = module.vpc.aws_vpc_id
  cidr_block = "0.0.0.0/0"
  igw_id = module.aws_igw.aws_igw_id
  tag = local.tag
}



module "rw_ass_subnet_a" {
  source = "./module/route_table_association"
  subnet_id      = module.public_subnet_easta.aws_subnet_id
  route_table_id = module.public_route_table.route_table_id
  
}


module "rw_ass_subnet_b" {
  source = "./module/route_table_association"
  subnet_id      = module.public_subnet_eastb.aws_subnet_id
  route_table_id = module.public_route_table.route_table_id

}


module "dynamodb" {
  source = "./module/dynamo_db"
  tag = local.tag
}

module "ec2_common_key" {
  source = "./module/ec2keyPair"
  public_key = var.public_key
  key_name = "tech"
}

module "ec2_security_group" {
  source = "./module/security_group"
  vpc_id = module.vpc.aws_vpc_id
  sg_ingress_rules = var.sg_ingress_rules
  name = "flash_app_sg"
  tag = {
    Name = "flash_app_sg"
  }
}

module "lb_security_group" {
  source = "./module/security_group"
  vpc_id = module.vpc.aws_vpc_id
  sg_ingress_rules = var.sg_ingress_rules
  name = "flash_app_lb_sg"
  tag = {
    Name = "flash_app_lb_sg"
  }
}


module "flash_app_instance" {
  source = "./module/ec2_instance"
  ami_id    = data.aws_ami.ubuntu.id 
  key_name = "tech"
  subnet_id =  module.public_subnet_easta.aws_subnet_id
  iam_instance_profile = "flash_app_instance_profile"
  security_groups = [module.ec2_security_group.aws_sg_id]
  tag = {
    Name = "flash_app_a"
  }
}

module "flash_app_instance_ha" {
  source = "./module/ec2_instance"
  ami_id    = data.aws_ami.ubuntu.id 
  key_name = "tech"
  subnet_id =  module.public_subnet_eastb.aws_subnet_id
  iam_instance_profile = "flash_app_instance_profile"
  security_groups = [module.ec2_security_group.aws_sg_id]
  tag = {
    Name = "flash_app_a"
  }
}

module "flash_app_iam_role" {
  source = "./module/iam_role"
}

module "flash_app_instance_profile" {
  source = "./module/ec2_instance_profile"
  name = "flash_app_instance_profile"
  role_name = module.flash_app_iam_role.iam_role_name
}

module "flash_app_alb" {
  source = "./module/load_balancer"
  name               = "flashapplb"
  load_balancer_type = "application"
  security_groups = [module.lb_security_group.aws_sg_id]
  lb_subnet_id = local.lb_subnet_id
  tag = local.tag
}

module "flash_app_alb_tg" {
  source = "./module/lb_target_group"
  name               = "flash-app-tg"
  vpc_id             = module.vpc.aws_vpc_id
  health_check       = var.target_group_health_check
}

module "target_group_attachment_a" {
  source = "./module/target_group_attachement"
  target_group_arn = module.flash_app_alb_tg.tg_arn
  instance_id        = module.flash_app_instance.instance_id
  port             = "8000"
}

module "target_group_attachment_b" {
  source = "./module/target_group_attachement"
  target_group_arn = module.flash_app_alb_tg.tg_arn
  instance_id        = module.flash_app_instance_ha.instance_id
  port             = "8000"
}


module "alb_listener_rule" {
  source = "./module/lb_listener"
  load_balancer_arn    = module.flash_app_alb.lb_arb
  target_group_arn = module.flash_app_alb_tg.tg_arn
}


#terraform apply  -var-file=dev.tfvars --lock=false 
#terraform plan -var "aws_region=ap-south-1" -var "aws_access_key=****" -var "aws_secret_key=****"
#terraform apply -var "aws_region=ap-south-1" -var "aws_access_key=****" -var "aws_secret_key=****"
#terraform init -var "aws_region=ap-south-1" -var "aws_access_key=****" -var "aws_secret_key=****"
#terraform init -backend-config="access_key=****" -backend-config="secret_key=****"
#****
#****
#initializing a purtcular module
#terraform destroy -var "aws_region=ap-south-1" -var "aws_access_key=****" -var "aws_secret_key=****" -target="module.public_subnet"
