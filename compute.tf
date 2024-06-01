resource "aws_instance" "my-bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  depends_on = [aws_security_group.public_sg]
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = var.private_ec2_name
  }
}

resource "aws_instance" "ec2_instance_private" {
  count           = length(var.ec2_instance_names)
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.public_subnet[0].id
  depends_on      = [aws_security_group.private_sg]
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = var.ec2_instance_names[count.index]
  }
}
