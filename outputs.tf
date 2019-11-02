output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "all_subnet_ids" {
  value = "${data.aws_subnet_ids.vpc-subnet-ids.ids}"
}

