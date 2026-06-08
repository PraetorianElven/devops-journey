# GitLab CI — `.gitlab-ci.yml`, Pipelines e Runners

## Objetivo

Entender como o GitLab CI executa pipelines a partir do arquivo `.gitlab-ci.yml`.

GitLab CI é parecido com GitHub Actions, mas a estrutura gira em torno de `stages`, `jobs` e `runners`.

## Arquivo principal

```text
.gitlab-ci.yml
```

## Pipeline básico

```yaml
stages:
  - test
  - build

test:
  stage: test
  image: node:20
  script:
    - npm ci
    - npm test

build:
  stage: build
  image: docker:27
  services:
    - docker:27-dind
  script:
    - docker build -t minha-api:$CI_COMMIT_SHORT_SHA .
```

## Conceitos

| Conceito | Função |
| --- | --- |
| `stages` | ordem lógica do pipeline |
| job | bloco que executa comandos |
| runner | máquina/agente que executa o job |
| `image` | container usado para executar o job |
| `script` | comandos do job |
| variables | variáveis de ambiente |

## Variáveis importantes

| Variável | Exemplo de uso |
| --- | --- |
| `CI_COMMIT_SHA` | tag de imagem completa |
| `CI_COMMIT_SHORT_SHA` | tag curta |
| `CI_COMMIT_BRANCH` | regras por branch |
| `CI_REGISTRY_IMAGE` | imagem no registry do GitLab |

## Build e push para registry

```yaml
stages:
  - build

build-image:
  stage: build
  image: docker:27
  services:
    - docker:27-dind
  script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" "$CI_REGISTRY"
    - docker build -t "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA" .
    - docker push "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA"
```

## Regras por branch

```yaml
deploy-prod:
  stage: deploy
  script:
    - echo "deploy produção"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

## Runner

Runner é o executor do GitLab CI. Pode ser:

- compartilhado pelo GitLab
- instalado em uma VM própria
- instalado dentro de Kubernetes

Ver runners no projeto:

```text
Settings → CI/CD → Runners
```

## Mini-desafio

1. Crie `.gitlab-ci.yml`.
2. Configure stages `test` e `build`.
3. Use uma imagem Docker para rodar o job.
4. Adicione regra para deploy só na branch `main`.
5. Leia as variáveis `CI_COMMIT_SHORT_SHA` e `CI_COMMIT_BRANCH`.
