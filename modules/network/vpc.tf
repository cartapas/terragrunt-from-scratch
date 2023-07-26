resource "aws_vpc" "main" {
  cidr_block            = var.cidr_block
  instance_tenancy      = "default"
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = merge({
    Name        = "${var.projectname}-${var.environment}-VPC"
  },
    var.common_tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id  = aws_vpc.main.id
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-IGW"
  },
    var.common_tags
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

## Subnets
resource "aws_subnet" "public_subnet" {
  count                     = var.no_of_az
  cidr_block                = cidrsubnet(var.cidr_block,8,(count.index))
  vpc_id                    = aws_vpc.main.id
  map_public_ip_on_launch   = true
  availability_zone         = data.aws_availability_zones.available.names[count.index]
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-public-subnet-${count.index}"
  },
    var.common_tags
  )
}

resource "aws_subnet" "private_subnet" {
  count               = var.no_of_az
  cidr_block          = cidrsubnet(var.cidr_block,8,(count.index + var.no_of_az))
  vpc_id              = aws_vpc.main.id
  availability_zone   = data.aws_availability_zones.available.names[count.index]
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-private-subnet-${count.index}"
  },
    var.common_tags
  )
}

## NAT & ElasticIP
resource "aws_eip" "aws_eip" {
  count     = var.single_nat_gateway == false ? var.no_of_az : 1
  vpc = true
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-elasticIP-${count.index + 1}"
  },
    var.common_tags
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count           = var.single_nat_gateway == false ? var.no_of_az : 1
  allocation_id   = aws_eip.aws_eip[count.index].id
  subnet_id       = aws_subnet.public_subnet[count.index].id
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-natgateway-${count.index + 1}"
  },
    var.common_tags
  )
}

## Routing public
resource "aws_route_table" "public_route_table" {
  vpc_id          = aws_vpc.main.id
  route {
      cidr_block  = "0.0.0.0/0"
      gateway_id  = aws_internet_gateway.igw.id
  }
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-publicRT"
  },
    var.common_tags
  )
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  count             = var.no_of_az
  subnet_id         = aws_subnet.public_subnet[count.index].id
  route_table_id    = aws_route_table.public_route_table.id
}

## Routing Private
resource "aws_route_table" "private_route_table" {
  count           = var.no_of_az
  vpc_id          = aws_vpc.main.id
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-privateRT-${count.index + 1}"
  },
    var.common_tags
  )
}

resource "aws_route" "private_route_nat" {
  count                   = var.no_of_az
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = var.single_nat_gateway == false ? aws_nat_gateway.nat_gateway[count.index].id : aws_nat_gateway.nat_gateway[0].id
  route_table_id          = aws_route_table.private_route_table[count.index].id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  count           = var.no_of_az
  subnet_id       = aws_subnet.private_subnet[count.index].id
  route_table_id  = aws_route_table.private_route_table[count.index].id
}

## Internal hosted zones
resource "aws_route53_zone" "internal" {
  name = "${var.environment}.internal"
  vpc {
    vpc_id = aws_vpc.main.id
  }
  tags = merge({
    Name        = "${var.projectname}-${var.environment}-hosted-zone"
  },
    var.common_tags
  )
}