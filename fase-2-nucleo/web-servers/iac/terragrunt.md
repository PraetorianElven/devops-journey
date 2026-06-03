# Terragrunt — Organização e Reuso com Terraform

## Objetivo

Entender Terragrunt como camada auxiliar para organizar projetos Terraform grandes.

Terragrunt não substitui Terraform. Ele chama Terraform, mas ajuda com:

- configuração de backend repetida
- variáveis comuns
- estrutura multiambiente
- dependências entre módulos

## Problema que ele resolve

Sem Terragrunt, você pode repetir backend e providers em várias pastas:

```text
dev/app
dev/database
prod/app
prod/database
```

Com Terragrunt, parte da configuração fica centralizada.

## Estrutura comum

```text
infra/
├── terragrunt.hcl
├── dev/
│   ├── app/terragrunt.hcl
│   └── database/terragrunt.hcl
└── prod/
    ├── app/terragrunt.hcl
    └── database/terragrunt.hcl
```

## `terragrunt.hcl` raiz

```hcl
remote_state {
  backend = "s3"

  config = {
    bucket         = "empresa-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

## Ambiente específico

`dev/app/terragrunt.hcl`:

```hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/app"
}

inputs = {
  environment = "dev"
  replicas    = 1
}
```

`prod/app/terragrunt.hcl`:

```hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/app"
}

inputs = {
  environment = "prod"
  replicas    = 3
}
```

## Comandos

```bash
terragrunt init
terragrunt plan
terragrunt apply
terragrunt run-all plan
```

## Quando usar

| Cenário | Terragrunt ajuda? |
| --- | --- |
| um projeto pequeno | talvez não |
| muitos ambientes | sim |
| muitos módulos repetindo backend | sim |
| dependências entre stacks | sim |

## Mini-desafio

1. Crie uma pasta `dev/app`.
2. Crie um `terragrunt.hcl` raiz com backend S3.
3. Crie um `terragrunt.hcl` do app apontando para um módulo.
4. Passe inputs diferentes para `dev` e `prod`.
5. Compare com Terraform puro.
