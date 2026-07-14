locals {
  create_sg                   = var.create && var.create_security_group
  create_iam_instance_profile = var.create && var.iam_instance_profile == null && var.create_iam_instance_profile
  iam_instance_profile        = coalesce(var.iam_instance_profile, try(aws_iam_instance_profile.this[0].name, null))
}

resource "aws_iam_role" "this" {
  count = local.create_iam_instance_profile ? 1 : 0

  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count = local.create_iam_instance_profile ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  count = local.create_iam_instance_profile ? 1 : 0

  name = "${var.name}-profile"
  role = aws_iam_role.this[0].name

  tags = var.tags
}

resource "aws_security_group" "this" {
  count = local.create_sg ? 1 : 0

  name        = "${var.name}-sg"
  description = "Security group for ${var.name} EC2 instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(
    { "Name" = "${var.name}-sg" },
    var.tags,
  )
}

resource "aws_instance" "this" {
  count = var.create ? 1 : 0

  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  iam_instance_profile   = local.iam_instance_profile
  user_data              = var.user_data
  monitoring             = var.monitoring
  vpc_security_group_ids = concat(var.vpc_security_group_ids, aws_security_group.this[*].id)


  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_size = var.root_block_device_size
    volume_type = var.root_block_device_type
    encrypted   = var.root_block_device_encrypted
  }

  tags = merge(
    { "Name" = var.name },
    var.tags,
  )
}
