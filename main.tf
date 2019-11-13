data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidrblock}"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "backend-subnet" {
  count                   = 3
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidrblock, 3, count.index)}"
  map_public_ip_on_launch = false
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
}

resource "aws_subnet" "frontend-subnet" {
  count = 3
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidrblock, 3, count.index+4)}"
  map_public_ip_on_launch = true
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "frontend-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route_table" "backend-route-table" {
  count = 3
  vpc_id = "${aws_vpc.vpc.id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "backend-default-route" {
  count = 3
  route_table_id         = "${element(aws_route_table.backend-route-table.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id             = "${element(aws_nat_gateway.nat-gw.*.id, count.index)}"
}

resource "aws_route" "frontend-default-route" {
  route_table_id = "${aws_route_table.frontend-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet-gw.id}"
}


resource "aws_route_table_association" "backend-route-table-association" {
  count          = 3
  subnet_id      = "${element(aws_subnet.backend-subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.backend-route-table.*.id, count.index)}"
}

resource "aws_route_table_association" "frontend-route-table-association" {
  count          = 3
  subnet_id      = "${element(aws_subnet.frontend-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.frontend-route-table.id}"
}

resource "aws_nat_gateway" "nat-gw" {
  count = 3
  allocation_id = "${element(aws_eip.nat-gw-eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.frontend-subnet.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.internet-gw"]
}

resource "aws_eip" "nat-gw-eip" {
  count = 3
}

