# DevOps Study Plan — 30 / 60 / 90 Days
> Baseado em: https://roadmap.sh/devops
> Criado em: 2026-04-01
> Objetivo: Dominar DevOps de forma progressiva e estruturada
---
## Como usar este plano
- [ ] Marque os tópicos concluídos trocando `[ ]` por `[x]`
- Ajuste os tópicos conforme seu nível atual
- Adicione links de recursos na coluna de anotações
- Revise ao final de cada fase antes de avançar
---
## Estrutura de Pastas do Repositório
> Diga para organizar o repositório chamado `devops-journey` e organize assim:
```
devops-journey/
│
├── README.md                        # Visão geral do repositório e seu progresso
│
├── fase-1-fundacao/                 # Dias 1–30
│   ├── README.md                    # Resumo do que foi aprendido na fase
│   ├── linux/
│   │   ├── comandos-uteis.md        # Anotações e cheatsheet pessoal
│   │   └── permissoes.md
│   ├── bash/
│   │   ├── inventario-sistema.sh    # Desafio 1
│   │   └── diagnostico-rede.sh      # Desafio 3
│   ├── git/
│   │   └── fluxo-branches.md        # Anotações sobre o workflow Git
│   ├── redes/
│   │   └── anotacoes-osi-dns.md
│   └── python/
│       └── script-api.py            # Desafio 5
│
├── fase-2-nucleo/                   # Dias 31–60
│   ├── README.md
│   ├── docker/
│   │   ├── Dockerfile               # Desafio 1
│   │   ├── docker-compose.yml       # Desafio 2
│   │   └── anotacoes.md
│   ├── nginx/
│   │   ├── nginx.conf               # Desafio 5
│   │   └── ssl-setup.md
│   ├── cicd/
│   │   ├── .github/
│   │   │   └── workflows/
│   │   │       └── pipeline.yml     # Desafio 3
│   │   └── Argocd/FluxCD
│   ├── terraform/
│   │   ├── main.tf                  # Desafio 4
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── backend.tf
│   └── cloud/
│       └── aws-anotacoes.md
│
├── fase-3-avancado/                 # Dias 61–90
│   ├── README.md
│   ├── kubernetes/
│   │   ├── deployment.yaml          # Desafio 1
│   │   ├── service.yaml
│   │   ├── ingress.yaml
│   │   └── configmap.yaml
│   ├── helm/
│   │   └── minha-app/              # Desafio 2 — Helm Chart
│   │       ├── Chart.yaml
│   │       ├── values.yaml
│   │       └── templates/
│   ├── observabilidade/
│   │   ├── prometheus/
│   │   │   └── prometheus.yml       # Desafio 3
│   │   └── grafana/
│   │       └── dashboard.json
│   ├── segredos/
│   │   ├── vault-setup.md           # Desafio 4
│   │   └── sealed-secret.yaml
|   |    External-secrets
│   └── projeto-final/               # Desafio 5 — Integrador
│       ├── README.md                # Diagrama e documentação da arquitetura
│       ├── terraform/
│       ├── ansible/
│       │   └── playbook.yml
│       └── .github/
│           └── workflows/
│               └── deploy.yml
│
└── recursos/
    ├── links-uteis.md               # Links de cursos, docs e referências
    └── glossario.md                 # Termos e conceitos resumidos
```
> **Dica:** Cada `README.md` dentro das pastas de fase deve conter o que você aprendeu, dificuldades encontradas e como resolveu. Isso vira seu portfólio.
---
## Fase 1 — Dias 1 a 30: Fundação
> Meta: Ter base sólida em SO, terminal, Git e networking básico.
### Sistema Operacional & Terminal
- [X] Bash — scripts básicos, variáveis, loops, condicionais
- [X] Vim / Nano — edição de arquivos no terminal
- [X] Process Monitoring — `top`, `htop`, `ps`, `kill`
- [X] Performance Monitoring — `df`, `du`, `iostat`, `vmstat`
- [X] Text Manipulation — `grep`, `sed`, `awk`, `cut`, `sort`
- [X] Networking Tools — `ping`, `curl`, `wget`, `netstat`, `ss`, `nmap`
### Controle de Versão
- [X] Git — commits, branches, merge, rebase, stash
- [ ] GitHub — pull requests, issues, actions básico
### Redes & Protocolos (Básico)
- [X] Modelo OSI — 7 camadas
- [X] DNS — como funciona, registros A, CNAME, MX
- [x] HTTP / HTTPS — métodos, status codes, headers
- [X] SSH — chaves, config, tunneling
- [X] NFS - FTP - SFTP
- [X] SSL / TLS — certificados, HTTPS, Let's Encrypt, mkcert
### Linguagem de Programação (escolha 1)
- [X] Python — scripts, automações, bibliotecas (requests, boto3)
- [ ] Go — (alternativa para ferramentas DevOps nativas)
---
### Desafio Final — Fase 1
> Complete todos os itens abaixo antes de avançar para a Fase 2.
- [x] **Desafio 1 — Script de inventário do sistema**
  Escreva um script Bash que colete e exiba: uso de CPU, memória, disco, IP da máquina e usuários logados. Salve a saída em um arquivo de log com timestamp.
- [x] **Desafio 2 — Ambiente Git completo**
  Crie um repositório no GitHub com: branch `main` e `develop`, faça ao menos 5 commits organizados, abra 1 pull request de `develop` → `main` e faça o merge. Use `.gitignore` e `README.md`.
- [x] **Desafio 3 — Diagnóstico de rede**
  Escreva um script que: resolva o DNS de 3 domínios, teste conectividade HTTP com `curl`, liste portas abertas na máquina e salve tudo em um relatório `.txt`.
  Diga leia sobre `nip.io` e `/etc/hosts`
- [x] **Desafio 4 — Acesso SSH seguro**
  Configure acesso SSH por chave (sem senha) para um servidor ou VM local. Desative login por senha no `sshd_config`. Documente os passos em um `README.md` no repositório.
- [x] **Desafio 5 — Automação com Python**
  Crie um script Python que leia um arquivo de texto, conte palavras, linhas e caracteres, e envie o resultado para uma API pública (ex: httpbin.org) via POST.
> **Critério de aprovação:** Todos os scripts funcionando, repositório Git organizado, README documentado.
---
## Fase 2 — Dias 31 a 60: Núcleo DevOps
> Meta: Containers, CI/CD, IaC e primeiros passos em Cloud.
### Web Servers
- [ ] Nginx — configuração de virtual hosts, proxy reverso
- [ ] Apache — configuração básica, módulos
- [ ] Caddy — HTTPS automático, config simplificada
### Containers
- [ ] Docker — imagens, containers, Dockerfile, volumes, redes
- [ ] Docker Compose — orquestração local multi-container
### CI/CD
- [ ] GitHub Actions — workflows, jobs, steps, secrets
- [ ] GitLab CI — `.gitlab-ci.yml`, pipelines, runners
- [ ] ArgoCD
- [ ] FluxCD
### Infraestrutura como Código (IaC)
- [ ] Terraform — providers, resources, state, plan/apply
- [ ] Terragrunt
- [ ] Atlantis
### Networking Avançado
- [ ] Proxy Reverso — Nginx como proxy, headers
- [ ] Load Balancer — conceitos, round-robin, least connections
- [ ] Firewall — iptables, ufw, grupos de segurança cloud
- [ ] Caching Server — Redis, Varnish, conceitos
### Cloud Provider (escolha 1 para focar)
- [ ] AWS — IAM, EC2, S3, VPC, RDS (fundamentos)
- [ ] Azure — (alternativa para ambientes Microsoft)
- [ ] GCP — (alternativa com foco em Kubernetes)
---
### Desafio Final — Fase 2
> Complete todos os itens abaixo antes de avançar para a Fase 3.
- [ ] **Desafio 1 — Aplicação containerizada**
  Crie uma aplicação web simples (Python Flask ou Node.js), escreva o `Dockerfile`, publique a imagem no Docker Hub e rode localmente com `docker run`.
- [ ] **Desafio 2 — Ambiente multi-container**
  Use Docker Compose para subir: 1 aplicação web + 1 banco de dados (PostgreSQL ou MySQL) + 1 Nginx como proxy reverso. Tudo deve se comunicar pela rede interna do Compose.
- [ ] **Desafio 3 — Pipeline CI/CD completo**
  No GitHub Actions (ou GitLab CI), crie um pipeline que: roda testes, faz build da imagem Docker, publica no registry e envia notificação de sucesso/falha. Dispare com push na branch `main`.
- [ ] **Desafio 4 — Infraestrutura com Terraform**
  Provisione via Terraform: 1 instância EC2 (ou VM equivalente), 1 bucket S3 (ou blob storage), security group com portas 22 e 80 liberadas. Gerencie o state remotamente (S3 backend ou Terraform Cloud). Pode ser usado o `localstack`
- [ ] **Desafio 5 — Nginx como proxy reverso com HTTPS**
  Configure o Nginx para servir 2 aplicações diferentes em subdomínios distintos, com certificado SSL via Let's Encrypt (Certbot). Redirecione HTTP → HTTPS automaticamente.
  `leia sobre mkcert`
> **Critério de aprovação:** Pipeline rodando no CI, infra provisionada via código, HTTPS funcionando, tudo versionado no Git.
---
## Fase 3 — Dias 61 a 90: Avançado & Produção
> Meta: Kubernetes, observabilidade, segredos e práticas de produção.
### Orquestração de Containers
- [ ] Kubernetes — pods, deployments, services, ingress, namespaces
- [ ] kubectl — comandos essenciais, contextos, logs
- [ ] Helm — charts, releases, repositórios
- [ ] GKE / EKS / AKS — Kubernetes gerenciado na cloud
### Gerenciamento de Configuração
- [ ] Ansible — playbooks, inventory, roles, variáveis
### Monitoramento de Infraestrutura
- [ ] Prometheus — métricas, exporters, PromQL básico
- [ ] Grafana — dashboards, datasources, alertas
- [ ] Opentelemetry
### Gerenciamento de Logs
- [ ] Elastic Stack (ELK) — Elasticsearch, Logstash, Kibana
- [ ] LOKI — alternativa open-source
### Gerenciamento de Traces
- [ ] Tempo
- [ ] Jaeger
### Gerenciamento de Segredos
- [ ] HashiCorp Vault — secrets engine, políticas, tokens
- [ ] Sealed Secrets — secrets no Kubernetes
- [ ] AWS Secrets Manager / SSM Parameter Store
- [ ] External Secrets
### Serverless (visão geral)
- [ ] AWS Lambda — funções, triggers, limits
- [ ] Cloudflare Workers — edge computing
---
### Desafio Final — Fase 3
> Este é o desafio de conclusão do plano. Simula um ambiente real de produção.
- [ ] **Desafio 1 — Deploy no Kubernetes**
  Faça o deploy da aplicação do Desafio 2 (Fase 2) no Kubernetes: crie `Deployment`, `Service`, `Ingress` e `ConfigMap`. Use `kubectl` para escalar para 3 réplicas e simule um rolling update sem downtime.
- [ ] **Desafio 2 — Helm Chart próprio**
  Empacote sua aplicação como um Helm Chart com variáveis configuráveis (imagem, replicas, resources). Faça o deploy via `helm install` e valide com `helm test`.
- [ ] **Desafio 3 — Observabilidade completa**
  Configure Prometheus + Grafana no cluster: colete métricas da aplicação e do cluster, crie um dashboard com CPU, memória e requisições por segundo. Configure um alerta que dispara se o pod reiniciar mais de 2 vezes. Instrumente a aplicação usando opentelemetry e utilize o colector para enviar metricas e traces, logs ELK ou Loki
- [ ] **Desafio 4 — Gestão de segredos**
  Substitua todas as variáveis de ambiente sensíveis (senhas, tokens) por segredos gerenciados: use Vault ou Sealed Secrets no Kubernetes. Nenhuma credencial deve estar em texto plano no repositório.
- [ ] **Desafio 5 — Projeto integrador final**
  Una tudo em um repositório único: Terraform provisiona o cluster, Ansible configura o ambiente base, GitHub Actions faz o CI e escolha a ferramenta de CD via Helm, Prometheus monitora, logs vão para ELK ou Loki. Documente a arquitetura com um diagrama no `README.md`.
> **Critério de aprovação:** Aplicação rodando em Kubernetes com monitoramento, alertas ativos, sem segredos expostos, pipeline automatizado de ponta a ponta, arquitetura documentada.
---
## Recursos Recomendados
| Tópico       | Recurso                                      |
|--------------|----------------------------------------------|
| Linux        | https://linuxjourney.com                     |
| Git          | https://learngitbranching.js.org             |
| Docker       | https://docs.docker.com/get-started          |
| Kubernetes   | https://kubernetes.io/docs/tutorials         |
| Terraform    | https://developer.hashicorp.com/terraform    |
| AWS          | https://aws.amazon.com/training              |
| Prometheus   | https://prometheus.io/docs/introduction      |
---
## Anotações Pessoais
> Use este espaço para registrar dificuldades, insights e links úteis.
-
---
_Plano gerado com base em: https://roadmap.sh/devops_ 
 
