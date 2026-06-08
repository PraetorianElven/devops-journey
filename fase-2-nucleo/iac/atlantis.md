# Atlantis — Terraform em Pull Requests

## Objetivo

Entender Atlantis como ferramenta para rodar `terraform plan` e `terraform apply` dentro do fluxo de Pull Request.

Atlantis é comum em equipes que querem revisão de infraestrutura antes do apply.

## Fluxo

```text
Pessoa abre Pull Request
↓
Atlantis recebe webhook
↓
Atlantis roda terraform plan
↓
time revisa o plano no PR
↓
comentário atlantis apply
↓
Atlantis aplica a mudança
```

## Comandos no Pull Request

```text
atlantis plan
atlantis apply
atlantis unlock
```

## Arquivo `atlantis.yaml`

```yaml
version: 3

projects:
  - name: dev-app
    dir: dev/app
    workspace: default
    autoplan:
      enabled: true
      when_modified:
        - "*.tf"
        - "../modules/app/**/*.tf"

  - name: prod-app
    dir: prod/app
    workspace: default
    autoplan:
      enabled: true
      when_modified:
        - "*.tf"
        - "../modules/app/**/*.tf"
```

## O que revisar no plan

| Item | Pergunta |
| --- | --- |
| recursos destruídos | deveria destruir mesmo? |
| recursos recriados | haverá downtime? |
| tags | ambiente, dono e custo estão corretos? |
| permissões IAM | estão amplas demais? |
| banco/storage | há risco de perda de dados? |

## Lock

Atlantis usa lock para evitar duas alterações simultâneas no mesmo estado.

Se um PR travar o lock, outro PR não deve aplicar em cima do mesmo state.

## Boas práticas

- exigir aprovação antes de `apply`
- proteger branch principal
- revisar sempre o plano completo
- separar projetos por diretório
- evitar `apply` em produção sem revisão

## Mini-desafio

1. Crie um `atlantis.yaml` com dois projetos: `dev-app` e `prod-app`.
2. Defina `dir` de cada projeto.
3. Configure `autoplan`.
4. Simule o fluxo: PR, `plan`, revisão, `apply`.
5. Liste quais mudanças no plan seriam perigosas.
