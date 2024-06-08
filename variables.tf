
# variables.tf

############################################################################################
#                                                                                          #
#                                      VPC VARIABLES                                       #
#                                                                                          #
############################################################################################
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Name = "my-vpc"
  }
}

variable "subnet_tags" {
  description = "Tags to apply to the subnets"
  type        = map(string)
  default = {
    Name = "my-subnet"
  }
}

variable "igw_tags" {
  description = "Tags to apply to the internet gateway"
  type        = map(string)
  default = {
    Name = "my-igw"
  }
}

variable "nat_gw_tags" {
  description = "Tags to apply to the NAT gateway"
  type        = map(string)
  default = {
    Name = "my-nat-gw"
  }
}

variable "public_route_table_tags" {
  description = "Tags to apply to the public route table"
  type        = map(string)
  default = {
    Name = "my-public-route-table"
  }
}

variable "private_route_table_tags" {
  description = "Tags to apply to the private route table"
  type        = map(string)
  default = {
    Name = "my-private-route-table"
  }
}

############################################################################################
#                                                                                          #
#                                      EC2 VARIABLES                                       #
#                                                                                          #
############################################################################################

variable "user" {
  description = "Names of EC2 instances user"
  type        = string
  default     = "ubuntu"
}

variable "ec2_instance_names" {
  description = "Names of EC2 instances"
  type        = list(string)
  default     = ["frontend", "backend", "metabase"]
}

variable "private_ec2_name" {
  description = "Names of EC2 instances"
  type        = string
  default     = "my-bastion"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type = string
  default     = "ami-04b70fa74e45c3917"  # Replace with your desired AMI ID
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type = string
  default     = "t2.micro"       # Replace with your desired instance type
}

variable "key_name" {
  description = "SSH key pair name for EC2 instances"
  type = string
  default     = "ubuntu-key"     # Replace with your SSH key pair name
}

variable "local_file_path" {
  description = "Local file to copy"
  type        = string
  default     = "ubuntu-key.pem"  # replace with your local file path
}

variable "remote_file_path" {
  description = "Remote file path on the instance"
  type        = string
  default     = "/home/ubuntu/ubuntu-key.pem"  # replace with your desired remote file path
}


############################################################################################
#                                                                                          #
#                                 SECURITY GROUP VARIABLES                                 #
#                                                                                          #
############################################################################################

variable "private_sg_name" {
  description = "Private security group name"
  type = string
  default    = "private-sg"
}

variable "public_sg_name" {
  description = "Public security group name"
  type = string
  default    = "public-sg"
}

variable "rds_sg_name" {
  description = "DB security group name"
  type = string
  default    = "rds-sg"
}

variable "load_balancer_sg_name" {
  description = "Load Balancer security group name"
  type = string
  default    = "load-balancer-sg"
}

variable "private_sg_tag" {
  description = "Tags to apply to the private security group"
  type        = map(string)
  default = {
    Name = "private-sg"
  }
}

variable "public_sg_tag" {
  description = "Tags to apply to the public security group"
  type        = map(string)
  default = {
    Name = "public-sg"
  }
}

variable "rds_sg_tag" {
  description = "Tags to apply to the RDS security group"
  type        = map(string)
  default = {
    Name = "rds-sg"
  }
}

variable "load_balancer_sg_tag" {
  description = "Tags to apply to the Load Balancer security group"
  type        = map(string)
  default = {
    Name = "lb-sg"
  }
}


variable "ssh_port" {
  description = "SSH port number"
  type = number
  default     = 22
}

variable "http_port" {
  description = "HTTP port number"
  type = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port number"
  type = number
  default     = 443
}

variable "custom_port" {
  description = "Custom port number"
  type = number
  default     = 4000
}

variable "mysql_port" {
  description = "MySQL port number"
  type = number
  default     = 3306
}


############################################################################################
#                                                                                          #
#                                      DB VARIABLES                                        #
#                                                                                          #
############################################################################################

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "mysql-instance"
}

variable "db_engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The database engine version to use"
  type        = string
  default     = "8.0.36"
}

variable "db_instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t3.micro"
}

variable "db_storage_type" {
  description = "The storage type to use"
  type        = string
  default     = "gp2"
}

variable "db_allocated_storage" {
  description = "The allocated storage size in gigabytes"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "db_mysql"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "password"
  sensitive   = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot before deletion"
  type        = bool
  default     = true
}

variable "db_subnet_group_tag" {
  description = "Tags to apply to the db subnet group"
  type        = map(string)
  default = {
    Name = "Main DB Subnet Group"
  }
}




variable "github_token" {
  description = "The GitHub token with repo access"
  type        = string
  sensitive   = true
}

variable "repository" {
  description = "The name of the GitHub repository"
  type        = string
}