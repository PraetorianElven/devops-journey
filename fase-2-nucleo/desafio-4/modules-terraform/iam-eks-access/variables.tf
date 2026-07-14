variable "create" {
  description = "Controls whether the IAM resources should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the IAM role used to access the EKS cluster"
  type        = string
}

variable "description" {
  description = "Description for the IAM role"
  type        = string
  default     = "IAM role for human access to EKS"
}

variable "path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Maximum session duration, in seconds, for the assumed role"
  type        = number
  default     = 3600
}

variable "trusted_principal_arns" {
  description = "IAM principal ARNs allowed to assume the role"
  type        = list(string)
}

variable "allow_assume_role_user_names" {
  description = "IAM user names that should receive an inline policy to assume the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}
