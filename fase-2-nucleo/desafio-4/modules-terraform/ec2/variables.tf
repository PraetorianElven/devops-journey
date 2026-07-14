variable "create" {
  description = "Controls whether the EC2 instance should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID used to launch the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "Whether to create a security group for the instance"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID used when creating the instance security group"
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "Ingress rules for the instance security group, keyed by rule name"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string, "")
  }))
  default = {}
}

variable "egress_rules" {
  description = "Egress rules for the instance security group, keyed by rule name"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string, "")
  }))
  default = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Key pair name used for SSH access"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Name of an existing IAM instance profile to attach to the instance. When null and create_iam_instance_profile is true, a profile with SSM access is created for you"
  type        = string
  default     = null
}

variable "create_iam_instance_profile" {
  description = "Whether to create an IAM role and instance profile (with AmazonSSMManagedInstanceCore attached) when iam_instance_profile is not provided"
  type        = bool
  default     = true
}

variable "root_block_device_size" {
  description = "Size, in GiB, of the root EBS volume"
  type        = number
  default     = 20
}

variable "root_block_device_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}

variable "root_block_device_encrypted" {
  description = "Whether the root EBS volume is encrypted"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script executed on instance boot"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "Whether detailed monitoring is enabled for the instance"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to all resources created by this module"
  type        = map(string)
  default     = {}
}
