resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.subnet_availability_zone
  map_public_ip_on_launch=var.public_ip_enabled
  tags = {
    Name = "public subnet"
  }
}