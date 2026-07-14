terraform {
  backend "s3" {
    bucket  = "s3-state-projeto-paulo"
    key     = "prd/terraform.tfstate"
    region  = "us-east-1"
    profile = "paulo"
  }
}