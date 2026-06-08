# Fase 2 - Nucleo

## Resumo da fase

Esta fase consolidou os fundamentos de web servers, containers, CI/CD, IaC, networking avancado e cloud, com foco pratico em AWS usando simulacao local.

### O que foi praticado

- documentacao de Nginx, Apache e Caddy para cenarios de proxy e publicacao
- conceitos e exemplos de Docker e Docker Compose para ambientes multi-container
- fundamentos de CI/CD com GitHub Actions, GitLab CI, ArgoCD e FluxCD
- base de Terraform, Terragrunt e Atlantis para infraestrutura como codigo
- conceitos de proxy reverso, load balancer, firewall, Redis e Varnish
- laboratorio local de AWS com LocalStack, AWS CLI e Terraform

### Dificuldades e como foram resolvidas

- criar laboratorios de cloud sem custo e sem conta real:
  a fase passou a usar `LocalStack` como simulador local de AWS
- praticar AWS CLI sem depender de credenciais reais:
  foi criado um wrapper `awslocal.sh` com `endpoint-url` e credenciais fake
- testar Terraform sem provisionar na nuvem:
  o provider AWS foi configurado para apontar para `http://localhost:4566`

## Como estudar

Use esta fase como material pratico. A ordem recomendada e:

1. Web servers
2. Containers
3. CI/CD
4. Infraestrutura como codigo
5. Networking avancado
6. Cloud provider

Em cada arquivo, leia o conceito, copie os exemplos para um laboratorio e rode os comandos de validacao. O objetivo nao e decorar comandos, mas entender o fluxo real de uma aplicacao em producao.

## Estrutura da fase

```text
fase-2-nucleo/
├── README.md
├── webservers/
├── containers/
├── cicd/
├── iac/
├── networking-avancado/
├── cloud-providers/
└── aws-simulator/
```

## Checklist da etapa

### Web Servers

- [ ] [Nginx — configuracao de virtual hosts e proxy reverso](./webservers/nginx.md)
- [ ] [Apache — configuracao basica e modulos](./webservers/apache.md)
- [ ] [Caddy — HTTPS automatico e config simplificada](./webservers/caddy.md)

### Containers

- [ ] [Docker — imagens, containers, Dockerfile, volumes e redes](./containers/docker.md)
- [ ] [Docker Compose — orquestracao local multi-container](./containers/docker-compose.md)

### CI/CD

- [ ] [GitHub Actions — workflows, jobs, steps e secrets](./cicd/github-actions.md)
- [ ] [GitLab CI — `.gitlab-ci.yml`, pipelines e runners](./cicd/gitlab-ci.md)
- [ ] [ArgoCD](./cicd/argocd.md)
- [ ] [FluxCD](./cicd/fluxcd.md)

### Infraestrutura como Codigo

- [ ] [Terraform — providers, resources, state, plan e apply](./iac/terraform.md)
- [ ] [Terragrunt](./iac/terragrunt.md)
- [ ] [Atlantis](./iac/atlantis.md)

### Networking Avancado

- [ ] [Proxy Reverso — Nginx como proxy e headers](./networking-avancado/proxy-reverso.md)
- [ ] [Load Balancer — conceitos, round-robin e least connections](./networking-avancado/load-balancer.md)
- [ ] [Firewall — iptables, ufw e grupos de seguranca cloud](./networking-avancado/firewall.md)
- [ ] [Caching Server — Redis](./networking-avancado/redis.md)
- [ ] [Caching Server — Varnish](./networking-avancado/varnish.md)

### Cloud Provider

- [ ] [AWS — IAM, EC2, S3, VPC e RDS](./cloud-providers/aws.md)
- [ ] [Azure — alternativa para ambientes Microsoft](./cloud-providers/azure.md)
- [ ] [GCP — alternativa com foco em Kubernetes](./cloud-providers/gcp.md)

## Status dos desafios

- `Desafio 1`: material base documentado em [containers/docker.md](/home/paulo/elven/devops-journey/fase-2-nucleo/containers/docker.md:1)
- `Desafio 2`: material base documentado em [containers/docker-compose.md](/home/paulo/elven/devops-journey/fase-2-nucleo/containers/docker-compose.md:1) e [webservers/nginx.md](/home/paulo/elven/devops-journey/fase-2-nucleo/webservers/nginx.md:1)
- `Desafio 3`: material base documentado em [cicd/github-actions.md](/home/paulo/elven/devops-journey/fase-2-nucleo/cicd/github-actions.md:1)
- `Desafio 4`: implementado com simulador em [aws-simulator/README.md](/home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator/README.md:1)
- `Desafio 5`: material base documentado em [webservers/nginx.md](/home/paulo/elven/devops-journey/fase-2-nucleo/webservers/nginx.md:1) e [networking-avancado/proxy-reverso.md](/home/paulo/elven/devops-journey/fase-2-nucleo/networking-avancado/proxy-reverso.md:1)

## Desafio 4 - Infraestrutura com Terraform e AWS local

O laboratorio desta fase fica em [aws-simulator/README.md](/home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator/README.md:1) e cobre:

- subir `LocalStack` com `docker compose`
- usar `AWS CLI` apontando para o endpoint local
- criar bucket S3 de teste
- aplicar infraestrutura via Terraform para S3, VPC, Security Group, IAM e EC2 simulada

### Como executar

```bash
cd /home/paulo/elven/devops-journey/fase-2-nucleo/aws-simulator
docker compose up -d
./scripts/bootstrap.sh
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

### O que foi validado

- `LocalStack` subindo com `docker compose`
- `AWS CLI` acessando `STS`, `S3`, `IAM` e `EC2`
- `Terraform init`, `validate`, `plan`, `apply` e `destroy`

## Observacao sobre o simulador

O `LocalStack` e excelente para estudar fluxo de CLI, API e Terraform, mas nao substitui completamente uma conta AWS real.

Pontos importantes:

- `EC2` simulada nao sobe uma VM real para SSH
- servicos e validacoes podem ter pequenas diferencas em relacao a AWS
- o laboratorio serve para treino de comandos, desenho de recursos e fluxo de provisionamento

## Proximo passo recomendado

Depois de validar o laboratorio local, replique o mesmo desenho em uma conta AWS real:

1. bucket S3
2. VPC com subnet publica
3. Security Group `22/80`
4. EC2 para aplicacao
5. IAM Role sem chave fixa na instancia

## Sugestao de pratica final

Monte uma aplicacao simples com este fluxo:

```text
Nginx
↓
Docker Compose
↓
App + Redis + Postgres
↓
GitHub Actions build/test
↓
Terraform desenhando a infra
```

Depois repita o desenho pensando em AWS:

```text
ALB
↓
EC2 ou EKS
↓
Aplicacao
↓
RDS + Redis + S3
```
