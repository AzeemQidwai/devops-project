resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = var.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = var.igw_tags
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = var.nat_gw_tags
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_subnet" "public_subnet" {
  count = 3

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(var.subnet_tags, { Name = "${var.subnet_tags.Name}-public-${data.aws_availability_zones.available.names[count.index]}" })
}

resource "aws_subnet" "private_subnet" {
  count = 3

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(var.subnet_tags, { Name = "${var.subnet_tags.Name}-private-${data.aws_availability_zones.available.names[count.index]}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.public_route_table_tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = var.private_route_table_tags
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "my-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
  
  tags = var.db_subnet_group_tag
}

data "aws_availability_zones" "available" {
  state = "available"
}


