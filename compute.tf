resource "aws_instance" "my-bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  depends_on = [aws_security_group.public_sg]
  vpc_security_group_ids = [aws_security_group.public_sg.id]

provisioner "file" {
    source      = "ubuntu-key.pem"
    destination = "/home/ubuntu/ubuntu-key.pem"
  }

connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("ubuntu-key.pem")
    timeout     = "4m"
  }

  tags = {
    Name = var.private_ec2_name
  }
}

resource "aws_instance" "ec2_instance_private" {
  count           = length(var.ec2_instance_names)
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.private_subnet[0].id
  depends_on      = [aws_security_group.private_sg]
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  user_data = file("userdata/install.sh")

  tags = {
    Name = var.ec2_instance_names[count.index]
  }
}
