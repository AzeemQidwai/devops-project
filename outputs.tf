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

output "frontend_attachment_info" {
  value = {
    instance_id = aws_lb_target_group_attachment.frontend_attachment.target_id
    arn         = aws_lb_target_group_attachment.frontend_attachment.id
  }
}

output "backend_attachment_info" {
  value = {
    instance_id = aws_lb_target_group_attachment.backend_attachment.target_id
    arn         = aws_lb_target_group_attachment.backend_attachment.id
  }
}