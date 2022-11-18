resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_block
    gateway_id = var.igw_id
  }

  tags = var.tag
}