# Acesso ao Cluster EKS no Ambiente Dev

## Objetivo

Este documento explica como o acesso ao cluster EKS do ambiente `dev` foi estruturado no Terraform e como o usuario `paulo` deve assumir a role para usar o `kubectl`.

## Visao geral

O acesso ao cluster nao e feito diretamente pelo usuario IAM.

O fluxo configurado e:

1. O usuario IAM `paulo` autentica na AWS usando o profile local `paulo`.
2. O usuario `paulo` assume uma IAM role administrativa de acesso ao EKS.
3. O cluster EKS autoriza essa role via `access_entries`.
4. O `kubectl` usa essa role para obter token e acessar o cluster.

Em termos praticos:

- o usuario IAM e a identidade inicial
- a role e o cracha temporario
- o EKS confia na role, nao no usuario diretamente

## Arquivos envolvidos

- [iam-access.tf](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/iam-access.tf:1)
- [eks.tf](/home/paulo/labs/infra-terraform-kubernetes/environments/dev/eks.tf:1)
- [main.tf](/home/paulo/labs/infra-terraform-kubernetes/modules-terraform/iam-eks-access/main.tf:1)

## O que foi criado

### 1. Modulo de IAM para acesso ao EKS

Foi criado o modulo local:

`../../modules-terraform/iam-eks-access`

Esse modulo cria:

- uma `aws_iam_role`
- a trust policy da role
- uma policy inline opcional no usuario para permitir `sts:AssumeRole`

## 2. Role criada no ambiente dev

No ambiente `dev`, foi criada a role:

`lab-dev-eks-admin-role`

Essa role:

- confia no usuario `paulo`
- pode ser assumida por ele
- sera usada para acesso administrativo ao cluster

## 3. Permissao dentro do cluster

No modulo `eks`, a role foi adicionada em `access_entries` com a policy:

`AmazonEKSClusterAdminPolicy`

Isso concede acesso administrativo no escopo do cluster inteiro.

## Como a confianca funciona

Existem dois lados obrigatorios:

### Trust policy da role

Ela diz que o usuario `paulo` pode assumir a role.

### Policy do usuario

Ela diz que o usuario `paulo` pode executar `sts:AssumeRole` nessa role.

Se um dos dois lados nao existir, o acesso falha.

## Como acessar o cluster

### Passo 1. Garantir que o Terraform foi aplicado

Depois de aplicar o Terraform, a role e o `access_entry` precisam existir na AWS.

Comandos sugeridos:

```bash
terraform plan
terraform apply
```

### Passo 2. Atualizar o kubeconfig usando a role

Use o comando abaixo:

```bash
aws eks update-kubeconfig \
  --name lab-dev-eks-paulo \
  --region us-east-1 \
  --profile paulo \
  --role-arn arn:aws:iam::062104739479:role/lab-dev-eks-admin-role
```

Esse comando faz o kubeconfig passar a usar a role para autenticacao no cluster.

### Passo 3. Testar o acesso

```bash
kubectl get nodes
```

Se tudo estiver correto, o comando deve listar os nodes do cluster.

## Como verificar se a role existe

```bash
aws iam get-role --role-name lab-dev-eks-admin-role --profile paulo
```

## Como verificar se o cluster recebeu a role

```bash
aws eks list-access-entries \
  --cluster-name lab-dev-eks-paulo \
  --region us-east-1 \
  --profile paulo
```

O ARN da role deve aparecer na lista.

## Comportamento esperado no dia a dia

O fluxo normal de uso sera:

1. trabalhar com o profile `paulo`
2. atualizar o kubeconfig com `--role-arn`
3. usar `kubectl` normalmente

Nao e necessario criar usuario Kubernetes manualmente.

Nao e necessario editar `aws-auth` ConfigMap para esse caso.

## Por que esse modelo e melhor

Esse modelo e melhor do que mapear o usuario IAM direto no cluster porque:

- usa credenciais temporarias por role
- separa identidade humana de permissao no cluster
- facilita reaproveitar o padrao em `prd`
- permite criar roles diferentes para admin, readonly e times

## Evolucao recomendada para producao

Quando voce evoluir para `prd`, o ideal e criar roles separadas, por exemplo:

- `eks-prod-admin-role`
- `eks-prod-readonly-role`
- `eks-prod-dev-team-a-role`

E mapear cada uma com a policy adequada no `access_entries`.

## Observacoes

- O cluster EKS autentica a role, nao o usuario diretamente.
- O profile `paulo` continua sendo a base local para chamar a AWS.
- O `kubectl` passa a funcionar porque o token sera emitido para a role autorizada no cluster.
