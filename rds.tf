resource "aws_db_instance" "mysql_db" {
  identifier           = var.db_identifier
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  storage_type         = var.db_storage_type
  allocated_storage    = var.db_allocated_storage
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = var.skip_final_snapshot
  db_subnet_group_name = aws_db_subnet_group.main.name
  depends_on = [ aws_security_group.rds_sg ]
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # reference the security group
}