Exemplo de estrutura real:

# Fluxo de Branches Git

## Branches principais

- `main`: produção / versão estável
- `develop`: integração de desenvolvimento
- `feature/*`: novas funcionalidades
- `fix/*`: correções
- `hotfix/*`: correção urgente em produção

---

## Fluxo padrão para nova feature

### 1. Atualizar repositório

```bash
git checkout develop
git pull origin develop


2. Criar branch
git checkout -b feature/monitoramento-rede

3. Trabalhar e commitar
git add .git commit -m "Adiciona script de diagnóstico de rede"

4. Enviar para remoto
git push origin feature/monitoramento-rede

5. Abrir Pull Request para develop

Correções rápidas
git checkout -b fix/erro-gitignore

Hotfix produção
git checkout -b hotfix/corrige-ssh

# Boas práticas

Nunca trabalhar direto na main
Commits pequenos e claros
Nomear branch por contexto
Sempre pull antes de começar
Revisar com git diff



# Padrão de nomes

feature/nome
fix/nome
hotfix/nome
docs/nome

Exemplos
feature/bash-monitoramentofix/readme-fase1docs/ssh-config
