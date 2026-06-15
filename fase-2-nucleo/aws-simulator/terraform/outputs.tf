output "bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "security_group_id" {
  value = aws_security_group.web.id
}

output "iam_role_arn" {
  value = aws_iam_role.app.arn
}

output "instance_id" {
  value = aws_instance.app.id
}
