variable "aws_profile" {
  description = "AWS CLI profile used by Terraform in this environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region for this environment"
  type        = string
}

variable "environment_name" {
  description = "Logical environment name"
  type        = string
}

variable "project_name" {
  description = "Project name used in tags"
  type        = string
}

variable "vpc_name" {
  description = "Name used by the VPC module"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_admin_role_name" {
  description = "Name of the IAM role used for EKS admin access"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zone_count" {
  description = "Number of availability zones to use"
  type        = number
}

variable "map_public_ip_on_launch" {
  description = "Whether public subnets should assign public IPs on launch"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "Whether the VPC should enable DNS hostnames"
  type        = bool
}

variable "enable_dns_support" {
  description = "Whether the VPC should enable DNS support"
  type        = bool
}

variable "enable_nat_gateway" {
  description = "Whether NAT gateway should be created"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Whether only one NAT gateway should be created"
  type        = bool
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "endpoint_private_access" {
  description = "Whether the EKS private endpoint is enabled"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Whether the EKS public endpoint is enabled"
  type        = bool
}

variable "cluster_creator_user_name" {
  description = "IAM user name allowed to assume the EKS admin role"
  type        = string
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
}

variable "node_group_instance_types" {
  description = "Instance types used by the managed node group"
  type        = list(string)
}

variable "node_group_ami_type" {
  description = "AMI type used by the managed node group"
  type        = string
}

variable "node_group_capacity_type" {
  description = "Capacity type used by the managed node group"
  type        = string
}

variable "node_group_disk_size" {
  description = "Disk size for the managed node group"
  type        = number
}

variable "node_group_min_size" {
  description = "Minimum node count"
  type        = number
}

variable "node_group_max_size" {
  description = "Maximum node count"
  type        = number
}

variable "node_group_desired_size" {
  description = "Desired node count"
  type        = number
}

variable "common_tags" {
  description = "Common tags applied to the environment resources"
  type        = map(string)
}

variable "vpc_tags" {
  description = "Additional tags applied to VPC resources"
  type        = map(string)
}
