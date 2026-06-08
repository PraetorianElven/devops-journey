# FluxCD — GitOps para Kubernetes

## Objetivo

Entender FluxCD como alternativa ao ArgoCD para GitOps em Kubernetes.

FluxCD também observa repositórios Git e aplica o estado desejado no cluster.

## Fluxo

```text
Git repository
↓
Flux Source Controller
↓
Flux Kustomize/Helm Controller
↓
Kubernetes
```

## Diferença prática para ArgoCD

| Ponto | ArgoCD | FluxCD |
| --- | --- | --- |
| interface web | forte | mais focado em CLI e CRDs |
| modelo | Application | GitRepository + Kustomization |
| operação | visual e declarativa | declarativa e Kubernetes-native |

## GitRepository

Define o repositório observado:

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: infra
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/empresa/infra.git
  ref:
    branch: main
```

## Kustomization

Define o caminho aplicado no cluster:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: minha-api
  namespace: flux-system
spec:
  interval: 5m
  path: ./apps/minha-api
  prune: true
  sourceRef:
    kind: GitRepository
    name: infra
  targetNamespace: producao
```

## Conceitos

| Recurso | Função |
| --- | --- |
| `GitRepository` | fonte Git |
| `Kustomization` | aplica manifests/kustomize |
| `HelmRelease` | instala chart Helm |
| `prune` | remove recursos que saíram do Git |
| `interval` | frequência de reconciliação |

## Mini-desafio

1. Crie um `GitRepository` para um repo de infra.
2. Crie uma `Kustomization` apontando para `apps/minha-api`.
3. Altere um manifest no Git.
4. Observe a reconciliação.
5. Compare mentalmente com a `Application` do ArgoCD.
