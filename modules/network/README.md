# Network module

According to the environment, there are different network requirements for the project:

- *Development*
  - A separate VPC with CIDR 10.0.0.0/16.
  - Three (3) public subnets in different availability zones inside the North Virginia (us-east-1) region.
    - public-subnet-0 -> 10.0.0.0/24
    - public-subnet-1 -> 10.0.1.0/24
    - public-subnet-2 -> 10.0.2.0/24
  - A single Internet Gateway for the public subnets.
  - Three (3) private subnets in different availability zones inside the North Virginia (us-east-1) region.
    - private-subnet-0 -> 10.0.3.0/24
    - private-subnet-1 -> 10.0.4.0/24
    - private-subnet-2 -> 10.0.5.0/24
  - A single NAT Gateway with its own Elastic IP address for the private subnets.
- *Staging*
  - A separate VPC with CIDR 11.0.0.0/16.
  - Three (3) public subnets in different availability zones inside the North Virginia (us-east-1) region.
    - public-subnet-0 -> 11.0.0.0/24
    - public-subnet-1 -> 11.0.1.0/24
    - public-subnet-2 -> 11.0.2.0/24
  - A single Internet Gateway for the public subnets.
  - Three (3) private subnets in different availability zones inside the North Virginia (us-east-1) region.
    - private-subnet-0 -> 11.0.3.0/24
    - private-subnet-1 -> 11.0.4.0/24
    - private-subnet-2 -> 11.0.5.0/24
  - A single NAT Gateway with its own Elastic IP address for the private subnets.
- *Production*
  - A separate VPC with CIDR 12.0.0.0/16.
  - Three (3) public subnets in different availability zones inside the North Virginia (us-east-1) region.
    - public-subnet-0 -> 12.0.0.0/24
    - public-subnet-1 -> 12.0.1.0/24
    - public-subnet-2 -> 12.0.2.0/24
  - A single Internet Gateway for the public subnets.
  - Three (3) private subnets in different availability zones inside the North Virginia (us-east-1) region.
    - private-subnet-0 -> 12.0.3.0/24
    - private-subnet-1 -> 12.0.4.0/24
    - private-subnet-2 -> 12.0.5.0/24
  - A single NAT Gateway with its own Elastic IP address for the private subnets.

## Requirements

- [Terraform 1.1.3.](https://releases.hashicorp.com/terraform/1.1.3/)
- [Terragrunt 0.45.8](https://github.com/gruntwork-io/terragrunt/releases/tag/v0.45.8)

## Providers

- [hashicorp/aws 3.71.0](https://registry.terraform.io/providers/hashicorp/aws/3.71.0)

## Inputs

- environment
- projectname
- aws_region
- common_tags
- single_nat_gateway
- cidr_block
- no_of_az

## Outputs

- vpc_id
- subnet_public
- subnet_private
- route53_internal_zone_id
- vpc_cidr_block
- subnet_avz

## Resources created

- module.network.aws_eip.aws_eip[0] -> fork-dev-elasticIP-1
- module.network.aws_internet_gateway.igw -> fork-dev-IGW
- module.network.aws_nat_gateway.nat_gateway[0] -> fork-dev-natgateway-1
- module.network.aws_route.private_route_nat[0] -> destination_cidr_block = "0.0.0.0/0"
- module.network.aws_route.private_route_nat[1] -> destination_cidr_block = "0.0.0.0/0"
- module.network.aws_route.private_route_nat[2] -> destination_cidr_block = "0.0.0.0/0"
- module.network.aws_route53_zone.internal -> name = "dev.internal"
- module.network.aws_route_table.private_route_table[0]
- module.network.aws_route_table.private_route_table[1]
- module.network.aws_route_table.private_route_table[2]
- module.network.aws_route_table.public_route_table -> fork-dev-publicRT
- module.network.aws_route_table_association.private_subnet_route_table_association[0]
- module.network.aws_route_table_association.private_subnet_route_table_association[1]
- module.network.aws_route_table_association.private_subnet_route_table_association[2]
- module.network.aws_route_table_association.public_subnet_route_table_association[0]
- module.network.aws_route_table_association.public_subnet_route_table_association[1]
- module.network.aws_route_table_association.public_subnet_route_table_association[2]
- module.network.aws_subnet.private_subnet[0] -> cidr_block = "10.0.3.0/24"
- module.network.aws_subnet.private_subnet[1] -> cidr_block = "10.0.4.0/24"
- module.network.aws_subnet.private_subnet[2] -> cidr_block = "10.0.5.0/24"
- module.network.aws_subnet.public_subnet[0] -> cidr_block = "10.0.0.0/24"
- module.network.aws_subnet.public_subnet[1] -> cidr_block = "10.0.1.0/24"
- module.network.aws_subnet.public_subnet[2] -> cidr_block = "10.0.2.0/24"
- module.network.aws_vpc.main -> cidr_block = "10.0.0.0/16"