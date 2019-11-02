data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
    cidr_block = "${var.cidrblock}"
    enable_dns_hostnames = true
    enable_dns_support   = true
}

resource "aws_subnet" "backend-subnet" {
  count = 3
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidrblock, 3, count.index )}"
  map_public_ip_on_launch = true
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "default-route" {
  route_table_id = "${aws_route_table.route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet-gw.id}"
}

resource "aws_route_table_association" "route-table-association" {
  count = 3
  subnet_id      = "${element(aws_subnet.backend-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.route-table.id}"
}

data "aws_subnet_ids" "vpc-subnet-ids" {
  vpc_id = "${aws_vpc.vpc.id}"
  depends_on = ["aws_subnet.backend-subnet"]
}
