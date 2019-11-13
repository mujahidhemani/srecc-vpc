output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "all_subnet_ids" {
  value = concat((aws_subnet.backend-subnet.*.id), (aws_subnet.frontend-subnet.*.id))
}

output "backend_subnet_ids" {
  value = aws_subnet.backend-subnet.*.id
}

output "frontend_subnet_ids" {
  value = aws_subnet.frontend-subnet.*.id
}


