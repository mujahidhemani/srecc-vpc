output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
  description = "The VPC ID"
}

output "all_subnet_ids" {
  value = concat((aws_subnet.backend-subnet.*.id), (aws_subnet.frontend-subnet.*.id))
  description = "All subnet IDs (both frontend and backend) in a single list"
}

output "backend_subnet_ids" {
  value = aws_subnet.backend-subnet.*.id
  description = "A list of all backend subnet IDs"
}

output "frontend_subnet_ids" {
  value = aws_subnet.frontend-subnet.*.id
  description = "A list of all frontend subnet IDs"
}


