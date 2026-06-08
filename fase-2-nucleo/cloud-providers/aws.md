# AWS — IAM, EC2, S3, VPC e RDS

## Objetivo

Estudar fundamentos de AWS com foco prático em infraestrutura para aplicações.

Para laboratorio local, use o simulador em [../aws-simulator/README.md](/home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator/README.md:1).

Arquitetura comum:

```text
Internet
↓
Security Group / Load Balancer
↓
EC2 ou Kubernetes
↓
Aplicação
↓
RDS / Redis / S3
```

## IAM

IAM controla identidade e permissão.

| Recurso | Função |
| --- | --- |
| User | identidade humana ou programática |
| Group | conjunto de usuários |
| Role | identidade assumida por serviço |
| Policy | documento JSON com permissões |

Exemplo de policy somente leitura em S3:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": "*"
    }
  ]
}
```

Boa prática: EC2 deve usar Role, não chave fixa dentro do servidor.

## EC2

EC2 é máquina virtual na AWS.

Acesso SSH:

```bash
ssh -i chave.pem ubuntu@IP_PUBLICO
```

Logs systemd:

```bash
journalctl -u nginx -n 100
```

No simulador local, `EC2` e apenas emulada. Isso permite praticar `AWS CLI` e Terraform, mas nao um acesso SSH real.

## Security Group

Security Group é firewall associado a recursos AWS.

Exemplo para servidor web:

| Porta | Origem | Motivo |
| --- | --- | --- |
| 22 | seu IP | SSH |
| 80 | `0.0.0.0/0` | HTTP |
| 443 | `0.0.0.0/0` | HTTPS |

Exemplo para banco:

| Porta | Origem | Motivo |
| --- | --- | --- |
| 5432 | security group da aplicação | Postgres |

## S3

S3 armazena objetos, como arquivos, backups e artefatos.

Casos de uso:

- upload de imagens
- logs
- backups
- state remoto do Terraform
- site estático

Conceitos:

| Conceito | Significado |
| --- | --- |
| bucket | contêiner de objetos |
| object key | caminho/nome do arquivo |
| versioning | versões de objetos |
| lifecycle | regras de expiração/transição |

## VPC

VPC é a rede privada dentro da AWS.

Estrutura:

```text
VPC
├── Public Subnet
│   └── recursos com rota para Internet Gateway
├── Private Subnet
│   └── recursos sem exposição direta
├── Route Table
├── Internet Gateway
└── NAT Gateway
```

Uso comum:

| Recurso | Subnet recomendada |
| --- | --- |
| Load Balancer público | public subnet |
| EC2 de aplicação | private subnet |
| RDS | private subnet |

## RDS

RDS é banco gerenciado.

Exemplos:

- PostgreSQL
- MySQL
- MariaDB
- SQL Server

Boas práticas:

- deixar em subnet privada
- liberar acesso só do security group da aplicação
- habilitar backup
- definir janela de manutenção
- monitorar CPU, memória, conexões e storage
- aplicar janelas de backup e manutencao com previsibilidade

## Laboratorio local com LocalStack

Se a ideia e praticar sem custo, a fase 2 agora traz um laboratorio local pronto.

Fluxo:

```text
docker compose
↓
LocalStack
↓
AWS CLI com endpoint local
↓
Terraform
↓
S3 + VPC + Security Group + IAM + EC2 simulada
```

### Passo a passo rapido

1. Subir o simulador:

```bash
cd /home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator
docker compose up -d
```

2. Validar a API:

```bash
./bin/awslocal.sh sts get-caller-identity
```

3. Criar bucket de teste:

```bash
./scripts/bootstrap.sh
```

4. Aplicar Terraform:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply -auto-approve
```

5. Conferir recursos:

```bash
../bin/awslocal.sh s3 ls
../bin/awslocal.sh ec2 describe-vpcs
../bin/awslocal.sh ec2 describe-security-groups
../bin/awslocal.sh iam list-roles
```

### O que este laboratorio resolve

- pratica `AWS CLI` sem conta real
- ajuda a entender `endpoint`, `region`, `credentials` e `state`
- permite exercitar o desafio 4 da fase 2 com baixo risco

### O que ele nao substitui

- comportamento completo da AWS real
- validacao de custo, cotas e IAM organizacional
- acesso SSH verdadeiro a uma EC2 produtiva

## Arquitetura moderna

```text
Cloudflare
↓
AWS ALB
↓
EC2 ou EKS
↓
Aplicação
↓
RDS + S3 + Redis
```

## Mini-desafio

1. Desenhe uma VPC com 2 public subnets e 2 private subnets.
2. Coloque ALB nas public subnets.
3. Coloque aplicação nas private subnets.
4. Coloque RDS em private subnets.
5. Defina security groups para cada camada.
6. Reproduza uma versao reduzida desse desenho no simulador local.
