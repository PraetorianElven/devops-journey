aws_profile               = "paulo"
aws_region                = "us-east-1"
environment_name          = "dev"
project_name              = "infra-terraform-kubernetes"
vpc_name                  = "lab-dev"
cluster_name              = "lab-dev-eks-paulo"
eks_admin_role_name       = "lab-dev-eks-admin-role"
vpc_cidr                  = "10.0.0.0/16"
availability_zone_count   = 2
map_public_ip_on_launch   = true
enable_dns_hostnames      = true
enable_dns_support        = true
enable_nat_gateway        = true
single_nat_gateway        = true
kubernetes_version        = "1.35"
endpoint_private_access   = true
endpoint_public_access    = true
cluster_creator_user_name = "paulo"
node_group_name           = "lab-node-group-name"
node_group_instance_types = ["t3.medium"]
node_group_ami_type       = "AL2023_x86_64_STANDARD"
node_group_capacity_type  = "ON_DEMAND"
node_group_disk_size      = 20
node_group_min_size       = 1
node_group_max_size       = 2
node_group_desired_size   = 1

common_tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Project     = "infra-terraform-kubernetes"
}

vpc_tags = {
  Environment = "dev"
  Project     = "lab-k8s"
}
