resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name                 = var.name
  description          = var.description
  path                 = var.path
  max_session_duration = var.max_session_duration

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_principal_arns
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_user_policy" "assume_role" {
  for_each = var.create ? toset(var.allow_assume_role_user_names) : toset([])

  name = "${var.name}-${each.value}-assume-role"
  user = each.value

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.this[0].arn
      }
    ]
  })
}
