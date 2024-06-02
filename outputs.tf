# outputs.tf

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "nat_gateway_eip" {
  value = aws_eip.nat.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}

output "my_bastion_public_ip" {
  value = aws_instance.my-bastion.public_ip
}

output "mysql_db_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}

output "ec2_instances_with_private_ips" {
  value = {
    for instance in aws_instance.ec2_instance_private :
    instance.tags.Name => instance.private_ip
  }
}