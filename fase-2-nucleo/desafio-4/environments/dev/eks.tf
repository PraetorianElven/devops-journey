module "eks" {
  source = "../../modules-terraform/eks"

  name                    = var.cluster_name
  kubernetes_version      = var.kubernetes_version
  depends_on              = [module.vpc]
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access

  create_kms_key    = false
  encryption_config = null

  # EKS Addons
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  access_entries = {
    eks_admin = {
      principal_arn = module.eks_admin_access.role_arn
      type          = "STANDARD"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_managed_node_groups = {
    (var.node_group_name) = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = var.node_group_instance_types
      ami_type       = var.node_group_ami_type
      capacity_type  = var.node_group_capacity_type
      disk_size      = var.node_group_disk_size

      min_size = var.node_group_min_size
      max_size = var.node_group_max_size
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = var.node_group_desired_size

      # This is not required - demonstrates how to pass additional configuration to nodeadm
      # Ref https://awslabs.github.io/amazon-eks-ami/nodeadm/doc/api/
      cloudinit_pre_nodeadm = [
        {
          content_type = "application/node.eks.aws"
          content      = <<-EOT
            ---
            apiVersion: node.eks.aws/v1alpha1
            kind: NodeConfig
            spec:
              kubelet:
                config:
                  shutdownGracePeriod: 30s
          EOT
        }
      ]
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
