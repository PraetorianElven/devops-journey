# Fluxo de Branches Git

## Branches principais

- `main`: versao estavel
- `develop`: integracao de desenvolvimento
- `feature/*`: novas funcionalidades
- `fix/*`: correcoes
- `hotfix/*`: correcoes urgentes em producao

## Fluxo padrao para nova feature

### 1. Atualizar a branch base

```bash
git checkout develop
git pull origin develop
```

### 2. Criar branch de trabalho

```bash
git checkout -b feature/monitoramento-rede
```

### 3. Trabalhar e commitar

```bash
git add .
git commit -m "feat: adiciona script de diagnostico de rede"
```

### 4. Enviar para o remoto

```bash
git push origin feature/monitoramento-rede
```

### 5. Abrir Pull Request

Abrir PR de `feature/monitoramento-rede` para `develop`.

## Fluxos de correcao

Correcao rapida:

```bash
git checkout -b fix/erro-gitignore
```

Hotfix de producao:

```bash
git checkout -b hotfix/corrige-ssh
```

## Boas praticas

- nunca trabalhar direto na `main`
- fazer commits pequenos e claros
- nomear branch pelo contexto da mudanca
- sempre sincronizar a branch antes de comecar
- revisar antes de commitar com `git diff`

## Padrao de nomes

- `feature/nome`
- `fix/nome`
- `hotfix/nome`
- `docs/nome`

## Pendencia da fase 1

Para fechar o desafio de Git desta fase ainda falta:

- atingir pelo menos 5 commits
- abrir PR de `develop` para `main`
- fazer o merge da PR
