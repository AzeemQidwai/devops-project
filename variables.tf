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
