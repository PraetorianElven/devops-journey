variable "region" {
  type        = string
  description = "Regiao usada no simulador AWS"
  default     = "us-east-1"
}

variable "aws_endpoint" {
  type        = string
  description = "Endpoint do LocalStack"
  default     = "http://localhost:4566"
}

variable "aws_access_key" {
  type        = string
  description = "Access key fake para LocalStack"
  default     = "test"
}

variable "aws_secret_key" {
  type        = string
  description = "Secret key fake para LocalStack"
  default     = "test"
}

variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3 do laboratorio"
  default     = "devops-journey-artifacts"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR da VPC do laboratorio"
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR da subnet publica"
  default     = "10.20.1.0/24"
}

variable "ami_id" {
  type        = string
  description = "AMI fake usada no simulador EC2"
  default     = "ami-12345678"
}
