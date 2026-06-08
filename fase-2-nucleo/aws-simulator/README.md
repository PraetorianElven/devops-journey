# AWS Simulator - LocalStack

## Objetivo

Praticar AWS localmente sem custo usando `LocalStack`, `AWS CLI` e `Terraform`.

Este laboratorio cobre:

- `S3`
- `IAM`
- `STS`
- `VPC`
- `Security Group`
- `EC2` simulada

## Estrutura

```text
aws-simulator/
├── bin/
│   └── awslocal.sh
├── scripts/
│   ├── bootstrap.sh
│   └── cleanup.sh
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars.example
│   └── variables.tf
└── docker-compose.yml
```

## Pre-requisitos

- `docker`
- `docker compose`
- `aws`
- `terraform`

Valide antes de iniciar:

```bash
docker --version
docker compose version
aws --version
terraform version
```

## 1. Subir o simulador

Entre na pasta:

```bash
cd /home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator
```

Suba o LocalStack:

```bash
docker compose up -d
```

Verifique saude do servico:

```bash
curl http://localhost:4566/_localstack/health
```

## 2. Usar AWS CLI apontando para o endpoint local

O wrapper [bin/awslocal.sh](/home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator/bin/awslocal.sh:1) injeta:

- `AWS_ACCESS_KEY_ID=test`
- `AWS_SECRET_ACCESS_KEY=test`
- `AWS_DEFAULT_REGION=us-east-1`
- `--endpoint-url=http://localhost:4566`

Teste de identidade:

```bash
./bin/awslocal.sh sts get-caller-identity
```

Listar buckets:

```bash
./bin/awslocal.sh s3 ls
```

## 3. Bootstrap rapido

O script [scripts/bootstrap.sh](/home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator/scripts/bootstrap.sh:1) cria um bucket de teste e valida o endpoint.

Execucao padrao:

```bash
./scripts/bootstrap.sh
```

Executando com nome customizado:

```bash
./scripts/bootstrap.sh meu-bucket-lab
```

## 4. Aplicar Terraform no simulador

Entre na pasta do Terraform:

```bash
cd /home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator/terraform
```

Copie o arquivo de exemplo:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Inicialize:

```bash
terraform init
```

Formate e valide:

```bash
terraform fmt
terraform validate
```

Veja o plano:

```bash
terraform plan
```

Aplique:

```bash
terraform apply -auto-approve
```

Veja os outputs:

```bash
terraform output
```

## 5. Inspecionar recursos criados

Buckets:

```bash
../bin/awslocal.sh s3 ls
```

VPCs:

```bash
../bin/awslocal.sh ec2 describe-vpcs
```

Security Groups:

```bash
../bin/awslocal.sh ec2 describe-security-groups
```

Instancias:

```bash
../bin/awslocal.sh ec2 describe-instances
```

Roles:

```bash
../bin/awslocal.sh iam list-roles
```

## 6. Limpeza

Destrua a infraestrutura do Terraform:

```bash
terraform destroy -auto-approve
```

Volte para a pasta do simulador e remova o bucket de bootstrap:

```bash
cd /home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator
./scripts/cleanup.sh
```

Pare o simulador:

```bash
docker compose down -v
```

## Limites do laboratorio

- `EC2` aqui e simulada; nao espere uma VM utilizavel via SSH
- a maior aderencia do laboratorio e em `AWS CLI`, `S3`, `IAM` e `Terraform`
- para validar comportamento de producao, repita depois em uma conta AWS real

## Como apresentar este desafio

Voce pode explicar a entrega desta forma:

1. subi um ambiente local que simula a AWS com `LocalStack`
2. validei a API com `AWS CLI` usando endpoint local
3. criei bucket S3 de teste
4. apliquei infraestrutura via Terraform
5. listei os recursos criados para comprovar o provisionamento
