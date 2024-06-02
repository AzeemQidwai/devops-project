resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ubuntu_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.key_name}.pem"

  provisioner "local-exec" {
    command = "chmod 600 ${var.key_name}.pem"
  }
}


resource "aws_instance" "my-bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ubuntu_key_pair.key_name
  subnet_id     = random_shuffle.public_subnet_shuffle.result[0]
  associate_public_ip_address = true
  depends_on = [aws_security_group.public_sg]
  vpc_security_group_ids = [aws_security_group.public_sg.id]

provisioner "file" {
    source      = var.local_file_path
    destination = var.remote_file_path
connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.user
    private_key = file("${aws_key_pair.ubuntu_key_pair.key_name}.pem")
    timeout     = "4m"
  }
}

provisioner "remote-exec" {
    inline = [ "chmod 600 ${var.remote_file_path}" ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.user
      private_key = file("${aws_key_pair.ubuntu_key_pair.key_name}.pem")
      timeout     = "4m"  
}
}
  tags = {
    Name = var.private_ec2_name
  }
}

resource "aws_instance" "ec2_instance_private" {
  count           = length(var.ec2_instance_names)
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.ubuntu_key_pair.key_name
  subnet_id       = aws_subnet.private_subnet[count.index].id
  depends_on      = [aws_security_group.private_sg]
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  user_data = file("userdata/install.sh")

  tags = {
    Name = var.ec2_instance_names[count.index]
  }
}

data "aws_instances" "frontend_instances" {
    depends_on = [ aws_instance.ec2_instance_private ]
  filter {
    name   = "tag:Name"
    values = ["frontend"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instances" "backend_instances" {
    depends_on = [ aws_instance.ec2_instance_private ]
  filter {
    name   = "tag:Name"
    values = ["backend"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}