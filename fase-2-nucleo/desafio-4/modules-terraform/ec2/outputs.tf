output "instance_id" {
  description = "ID of the EC2 instance"
  value       = try(aws_instance.this[0].id, null)
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = try(aws_instance.this[0].arn, null)
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = try(aws_instance.this[0].private_ip, null)
}

output "public_ip" {
  description = "Public IP address of the EC2 instance, if assigned"
  value       = try(aws_instance.this[0].public_ip, null)
}

output "security_group_id" {
  description = "ID of the security group created for the instance"
  value       = try(aws_security_group.this[0].id, null)
}
