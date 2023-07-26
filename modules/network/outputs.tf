output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_public" {
  value = aws_subnet.public_subnet.*.id
}
output "subnet_private" {
  value = aws_subnet.private_subnet.*.id
}
output "route53_internal_zone_id" {
  value = aws_route53_zone.internal.zone_id
}
output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}
output "subnet_avz" {
  value = data.aws_availability_zones.available.names.*
}