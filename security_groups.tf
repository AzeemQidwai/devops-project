resource "aws_security_group" "public_sg" {
  depends_on = [aws_vpc.main]
  name        = var.public_sg_name
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.public_sg_tag
}

resource "aws_security_group" "private_sg" {
  depends_on = [aws_vpc.main]
  name        = "private_sg_name"
  description = "Allow traffic from the load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.private_sg_tag
}

resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg_name
  description = "Allow SSH and MySQL traffic"
  depends_on  = [aws_vpc.main]
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow traffic from any IP address
  }

  ingress {
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow traffic from any IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # allow traffic to any IP address
  }

  tags = var.rds_sg_tag
}

resource "aws_security_group" "lb_sg" {
  depends_on = [aws_vpc.main]
  name        = var.load_balancer_sg_name
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.load_balancer_sg_tag
}