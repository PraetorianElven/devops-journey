# ArgoCD — GitOps para Kubernetes

## Objetivo

Entender ArgoCD como ferramenta GitOps: o Git vira a fonte da verdade do cluster Kubernetes.

Fluxo:

```text
Git repository
↓
ArgoCD monitora
↓
detecta diferença
↓
sincroniza Kubernetes
```

## Ideia principal

No deploy tradicional, o pipeline executa comandos contra o cluster.

No GitOps, o pipeline altera arquivos no Git, e o ArgoCD aplica o estado desejado no cluster.

## Namespace comum

```text
argocd
```

## Application

Exemplo de `Application` apontando para manifests Kubernetes:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: minha-api
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/empresa/infra.git
    targetRevision: main
    path: apps/minha-api
  destination:
    server: https://kubernetes.default.svc
    namespace: producao
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Campos importantes

| Campo | Função |
| --- | --- |
| `repoURL` | repositório observado |
| `targetRevision` | branch, tag ou commit |
| `path` | pasta com manifests |
| `destination.namespace` | namespace destino |
| `prune` | remove recursos apagados do Git |
| `selfHeal` | corrige mudanças manuais no cluster |

## Sync manual vs automático

| Modo | Comportamento |
| --- | --- |
| manual | ArgoCD mostra diferença e você sincroniza |
| automático | ArgoCD aplica mudanças sozinho |

## Drift

Drift acontece quando o estado real do cluster difere do estado no Git.

Exemplo:

```text
Git diz: replicas: 3
Cluster está: replicas: 1
```

Com `selfHeal`, ArgoCD volta o cluster para `replicas: 3`.

## Mini-desafio

1. Crie uma pasta `apps/minha-api`.
2. Coloque `deployment.yaml` e `service.yaml`.
3. Crie uma `Application` apontando para essa pasta.
4. Altere o número de réplicas no Git.
5. Observe o sync no ArgoCD.
