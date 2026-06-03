# Fase 2 — Web Servers, Containers, CI/CD, IaC, Networking e Cloud

## Como estudar

Use esta pasta como material prático. A ordem recomendada é:

1. Web servers
2. Containers
3. CI/CD
4. Infraestrutura como Código
5. Networking avançado
6. Cloud provider

Em cada arquivo, leia o conceito, copie os exemplos para um laboratório e rode os comandos de validação. O objetivo não é decorar comandos, mas entender o fluxo real de uma aplicação em produção.

## Checklist da etapa

### Web Servers

- [ ] [Nginx — configuração de virtual hosts, proxy reverso](webservers/nginx.md)
- [ ] [Apache — configuração básica, módulos](webservers/apache.md)
- [ ] [Caddy — HTTPS automático, config simplificada](webservers/caddy.md)

### Containers

- [ ] [Docker — imagens, containers, Dockerfile, volumes, redes](containers/docker.md)
- [ ] [Docker Compose — orquestração local multi-container](containers/docker-compose.md)

### CI/CD

- [ ] [GitHub Actions — workflows, jobs, steps, secrets](cicd/github-actions.md)
- [ ] [GitLab CI — `.gitlab-ci.yml`, pipelines, runners](cicd/gitlab-ci.md)
- [ ] [ArgoCD](cicd/argocd.md)
- [ ] [FluxCD](cicd/fluxcd.md)

### Infraestrutura como Código

- [ ] [Terraform — providers, resources, state, plan/apply](iac/terraform.md)
- [ ] [Terragrunt](iac/terragrunt.md)
- [ ] [Atlantis](iac/atlantis.md)

### Networking Avançado

- [ ] [Proxy Reverso — Nginx como proxy, headers](networking-avancado/proxy-reverso.md)
- [ ] [Load Balancer — conceitos, round-robin, least connections](networking-avancado/load-balancer.md)
- [ ] [Firewall — iptables, ufw, grupos de segurança cloud](networking-avancado/firewall.md)
- [ ] [Caching Server — Redis](networking-avancado/redis.md)
- [ ] [Caching Server — Varnish](networking-avancado/varnish.md)

### Cloud Provider

- [ ] [AWS — IAM, EC2, S3, VPC, RDS](cloud-providers/aws.md)
- [ ] [Azure — alternativa para ambientes Microsoft](cloud-providers/azure.md)
- [ ] [GCP — alternativa com foco em Kubernetes](cloud-providers/gcp.md)

## Sugestão de prática final

Monte uma aplicação simples com este fluxo:

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
Aplicação
↓
RDS + Redis + S3
```
