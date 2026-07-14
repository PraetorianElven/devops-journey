data "aws_caller_identity" "current" {}

module "eks_admin_access" {
  source = "../../modules-terraform/iam-eks-access"

  name = var.eks_admin_role_name

  trusted_principal_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.cluster_creator_user_name}"
  ]

  allow_assume_role_user_names = [var.cluster_creator_user_name]

  tags = merge(
    var.common_tags,
    {
      AccessScope = "eks-admin"
      Environment = var.environment_name
      Project     = var.project_name
    }
  )
}
