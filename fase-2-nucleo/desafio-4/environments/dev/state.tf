terraform {
  backend "s3" {
    bucket  = "s3-state-projeto-paulo"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    profile = "paulo"
  }
}