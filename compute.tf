resource "aws_instance" "ec2_instance_public" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on      = [aws_security_group.public_sg]
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ubuntu_key_pair.key_name

  user_data = file("${path.module}/userdata/install.sh")
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
  depends_on      = [aws_security_group.private_sg, aws_route_table.private, aws_route_table_association.private]
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  user_data = file("${path.module}/userdata/install.sh")

  tags = {
    Name = var.ec2_instance_names[count.index]
  }
}



/*
resource "aws_instance" "frontend" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.ubuntu_key_pair.key_name


  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install -y nginx
                systemctl start nginx
                systemctl enable nginx
                curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
                apt-get install -y nodejs
                EOF

  tags = {
    Name = "frontend"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[1].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.ubuntu_key_pair.key_name

  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install -y nginx docker.io
                systemctl start nginx
                systemctl enable nginx
                systemctl start docker
                systemctl enable docker
                curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
                apt-get install -y nodejs
                EOF

  tags = {
    Name = "backend"
  }
}

resource "aws_instance" "metabase" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[2].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.ubuntu_key_pair.key_name

  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install -y nginx docker.io
                systemctl start nginx
                systemctl enable nginx
                systemctl start docker
                systemctl enable docker
                curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
                apt-get install -y nodejs
                EOF

  tags = {
    Name = "metabase"
  }
}
*/

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