data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2" {
  source = "../../modules-terraform/ec2"

  name                   = var.ec2_name
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_instance_type
  root_block_device_size = var.ec2_disk_size

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  
  
  associate_public_ip_address = var.ec2_associate_public_ip_address

  ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
      description = "SSH from within the VPC"
    }
      wireguard = {
      from_port   = 51820
      to_port     = 51820
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "wireguard from internet"
    }
  }


  tags = merge(
    var.common_tags,
    {
      Environment = var.environment_name
      Project     = var.project_name
    }
  )
}
