# GitHub Actions — Workflows, Jobs, Steps e Secrets

## Objetivo

Entender como automatizar build, testes e deploy usando GitHub Actions.

Fluxo típico:

```text
git push
↓
GitHub detecta evento
↓
cria runner temporário
↓
executa jobs e steps
↓
publica artefato ou faz deploy
```

## Estrutura

```text
.github/
└── workflows/
    └── ci.yml
```

## Exemplo básico

```yaml
name: CI

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test
```

## Peças principais

| Peça | Função |
| --- | --- |
| `workflow` | arquivo YAML dentro de `.github/workflows` |
| `on` | evento que dispara o pipeline |
| `jobs` | grupos de execução |
| `runs-on` | sistema onde o job roda |
| `steps` | comandos ou actions dentro de um job |
| `secrets` | valores sensíveis armazenados no GitHub |

## Build de imagem Docker

```yaml
name: Docker

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build -t minha-api:${{ github.sha }} .

      - name: Test container
        run: |
          docker run -d --name api -p 3000:3000 minha-api:${{ github.sha }}
          sleep 3
          curl -f http://localhost:3000/health
```

## Secrets

Secrets ficam em:

```text
Settings → Secrets and variables → Actions
```

Uso:

```yaml
env:
  DOCKERHUB_USER: ${{ secrets.DOCKERHUB_USER }}
```

Nunca coloque senha, token ou chave privada direto no YAML.

## Deploy via SSH

Exemplo didático:

```yaml
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy by SSH
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd /opt/minha-api
            git pull
            docker compose up -d --build
```

## Mini-desafio

1. Crie `.github/workflows/ci.yml`.
2. Rode testes em cada `push`.
3. Adicione build Docker.
4. Adicione um secret fictício e leia no workflow.
5. Faça o job falhar de propósito e leia os logs.
