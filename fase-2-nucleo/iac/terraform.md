# Terraform — Providers, Resources, State e Plan/Apply

## Objetivo

Usar Terraform para criar infraestrutura como código.

Terraform lê arquivos `.tf`, compara com o estado atual e cria um plano de mudança.

```text
código Terraform
↓ terraform plan
plano
↓ terraform apply
infraestrutura criada/alterada
↓
state atualizado
```

## Estrutura

```text
terraform/
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

## Provider

Provider é o plugin que sabe conversar com uma API, como AWS, Azure, GCP, Kubernetes ou GitHub.

`providers.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}
```

## Variables

`variables.tf`:

```hcl
variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão criados"
}

variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3"
}
```

`terraform.tfvars`:

```hcl
region      = "us-east-1"
bucket_name = "meu-bucket-logs-dev"
```

## Resource

`main.tf`:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

## Output

`outputs.tf`:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.logs.bucket
}
```

## Comandos principais

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

## State

O state guarda o mapeamento entre o código e a infraestrutura real.

Arquivo local:

```text
terraform.tfstate
```

Em equipe, o state local não é uma boa ideia. Use backend remoto.

Exemplo com S3:

```hcl
terraform {
  backend "s3" {
    bucket         = "empresa-terraform-state"
    key            = "dev/app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

## Plan

`terraform plan` mostra o que será criado, alterado ou destruído.

Símbolos comuns:

| Símbolo | Significado |
| --- | --- |
| `+` | criar |
| `~` | alterar |
| `-` | destruir |
| `-/+` | recriar |

## Boas práticas

- rode `terraform fmt`
- rode `terraform validate`
- revise o `plan` antes do `apply`
- não commite `terraform.tfstate`
- use backend remoto em equipe
- separe ambientes por pasta ou workspace com critério claro

## Mini-desafio

1. Crie `providers.tf`, `variables.tf`, `main.tf` e `outputs.tf`.
2. Defina uma variável `bucket_name`.
3. Crie um bucket S3.
4. Rode `terraform init`, `validate` e `plan`.
5. Explique o que o plano vai fazer antes de aplicar.
