data "aws_vpc" "default_vpc" {
  filter {
    name = "tag:Name"
    values = ["${var.vpc_name_filter}"]
  }
}

data "aws_subnet_ids" "default_vpc_subnets" {
  vpc_id = "vpc-a8a5e6ce"

  filter {
    name = "tag:Name"
    values = ["default-*"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_route53_zone" "route_53_zone" {
  name = "teleimpact.io"
}