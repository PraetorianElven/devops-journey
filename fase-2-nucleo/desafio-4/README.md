# Infra Terraform Kubernetes

## Overview

Este repositório organiza a infraestrutura Kubernetes na AWS usando Terraform com separação por:

- `modules-terraform/`: módulos reutilizáveis
- `environments/`: composição por ambiente

Hoje o ambiente mais avançado é o `dev`, que já contém:

- VPC
- EKS
- role IAM para acesso humano ao cluster
- backend remoto no S3 para o state

O objetivo do projeto é manter:

- reuso nos módulos
- configuração isolada por ambiente
- state remoto centralizado
- controle de acesso ao EKS via IAM role + EKS access entries

## Arquitetura

Fluxo em alto nível:

1. O Terraform usa o profile AWS local para autenticar.
2. O backend S3 guarda o `terraform.tfstate`.
3. O ambiente `dev` chama módulos locais para criar VPC, EKS e acesso IAM.
4. O cluster EKS usa `access_entries` para autorizar a role administrativa.
5. O usuário assume a role ao gerar o kubeconfig e acessa o cluster com `kubectl`.

Em termos práticos:

- `modules-terraform/vpc`: rede base
- `modules-terraform/eks`: cluster e node groups
- `modules-terraform/iam-eks-access`: role de acesso humano ao EKS
- `environments/dev`: junta tudo isso com valores do ambiente

## Estrutura do projeto

```text
infra-terraform-kubernetes/
├── README.md
├── environments/
│   ├── dev/
│   │   ├── provider.tf
│   │   ├── state.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── vpc.tf
│   │   ├── eks.tf
│   │   ├── iam-access.tf
│   │   └── README-eks-access.md
│   └── prd/
└── modules-terraform/
    ├── vpc/
    ├── eks/
    └── iam-eks-access/
```

## Componentes

### VPC

Arquivo:
- [vpc.tf](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/vpc.tf:1)

Responsável por:
- criar a VPC
- criar subnets públicas e privadas
- habilitar DNS
- criar NAT Gateway

No `dev`, o ambiente usa:
- 2 Availability Zones
- 1 NAT Gateway
- CIDR `10.0.0.0/16`

### EKS

Arquivo:
- [eks.tf](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/eks.tf:1)

Responsável por:
- criar o cluster EKS
- habilitar endpoint privado e público
- instalar addons principais
- criar o managed node group
- registrar access entry da role administrativa

### Acesso IAM ao EKS

Arquivos:
- [iam-access.tf](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/iam-access.tf:1)
- [main.tf](/home/paulo/labs/infra-terraform-kubernetes/modules-terraform/iam-eks-access/main.tf:1)

Responsável por:
- criar a role IAM usada para acesso humano ao cluster
- permitir que o usuário IAM assuma essa role
- expor o ARN da role para o módulo EKS

## Variáveis do ambiente

Arquivos:
- [variables.tf](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/variables.tf:1)
- [terraform.tfvars](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/terraform.tfvars:1)

Padrão adotado:

- `variables.tf` declara tipos e intenções
- `terraform.tfvars` guarda os valores do ambiente

Isso facilita:
- reaproveitar o mesmo padrão em `prd`
- mudar apenas valores sem reescrever a composição

## Backend remoto no S3

Arquivo:
- [state.tf](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/state.tf:1)

Configuração atual do `dev`:

```hcl
terraform {
  backend "s3" {
    bucket  = "s3-state-projeto-paulo"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    profile = "paulo"
  }
}
```

### O que isso significa

- `bucket`: bucket S3 onde o state fica armazenado
- `key`: caminho do arquivo de state dentro do bucket
- `region`: região do bucket
- `profile`: profile AWS usado para acessar o backend

### Como apontar para o state no S3

Entre no diretório do ambiente:

```bash
cd ~/labs/infra-terraform-kubernetes/environments/dev
```

Depois inicialize o Terraform:

```bash
terraform init
```

Esse comando:

- lê o bloco `backend "s3"`
- conecta no bucket configurado
- passa a usar o state remoto

Se você alterar bucket, key, region ou profile do backend:

```bash
terraform init -reconfigure
```

Se estiver migrando um state antigo:

```bash
terraform init -migrate-state
```

## Como subir o ambiente

### 1. Entrar no diretório do ambiente

```bash
cd ~/labs/infra-terraform-kubernetes/environments/dev
```

### 2. Inicializar o Terraform

```bash
terraform init
```

### 3. Revisar o plano

```bash
terraform plan
```

### 4. Aplicar

```bash
terraform apply
```

### 5. Validar

Exemplos:

```bash
aws eks list-clusters --region us-east-1 --profile paulo
aws eks list-nodegroups --cluster-name lab-dev-eks-paulo --region us-east-1 --profile paulo
```

## Acesso ao cluster EKS

Documentação detalhada:
- [README-eks-access.md](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/README-eks-access.md:1)

Resumo do modelo:

1. O usuário `paulo` autentica com o profile AWS local.
2. O usuário assume a role `lab-dev-eks-admin-role`.
3. O EKS autoriza a role por `access_entries`.
4. O `kubectl` usa essa role para obter token.

### Comando para configurar o kubeconfig

```bash
aws eks update-kubeconfig \
  --name lab-dev-eks-paulo \
  --region us-east-1 \
  --profile paulo \
  --role-arn arn:aws:iam::062104739479:role/lab-dev-eks-admin-role
```

### Teste de acesso

```bash
kubectl get nodes
```

## Fluxo operacional recomendado

Para trabalhar no `dev`:

1. atualizar `terraform.tfvars` se necessário
2. rodar `terraform init`
3. rodar `terraform plan`
4. rodar `terraform apply`
5. atualizar kubeconfig com `--role-arn`
6. validar com `kubectl`

## Observações importantes

- A pasta `.terraform/` é local e ainda existe mesmo usando remote state.
- O state oficial fica no S3, não dentro da pasta do projeto.
- O arquivo `.terraform.lock.hcl` deve ser mantido.
- O diretório `.terraform/` não deve ser versionado.
- O acesso ao EKS deve ser feito por role, não diretamente por usuário IAM.

## Próximos passos naturais

- criar a composição de `prd`
- reutilizar o módulo `iam-eks-access` para perfis diferentes
- separar roles de admin, readonly e times
- revisar naming e tags para manter padrão único entre ambientes
