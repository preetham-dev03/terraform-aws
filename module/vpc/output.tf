output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}

output "aws_vpc_id" {
    value = aws_vpc.main.id
}