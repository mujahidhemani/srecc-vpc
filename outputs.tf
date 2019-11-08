output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "all_subnet_ids" {
  value = "${data.aws_subnet_ids.vpc-subnet-ids.ids}"
}

output "backend_subnet_ids" {
  value = aws_subnet.backend-subnet.*.id
}

output "frontend_subnet_ids" {
  value = aws_subnet.frontend-subnet.*.id
}


