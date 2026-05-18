# Fase 1 - Fundacao

## Resumo da fase

Esta fase consolidou a base de Linux, Bash, Git, redes e automacao simples em Python.

### O que foi praticado

- Scripts Bash para inventario de sistema e diagnostico de rede
- Estrutura de branches `main` e `develop`
- Documentacao de acesso SSH por chave
- Anotacoes sobre OSI, DNS, `/etc/hosts` e `nip.io`
- Automacao em Python com leitura de arquivo e envio de POST para API publica

### Dificuldades e como foram resolvidas

- Ferramentas podem variar entre distribuicoes:
  scripts usam fallback entre `ss` e `netstat`, e entre `dig`, `host` e `nslookup`
- Ambientes restritos podem bloquear DNS, socket ou descoberta de IP:
  os scripts registram a falha no relatorio em vez de encerrar silenciosamente
- O desafio de Python foi ajustado para bater exatamente com o enunciado da fase:
  leitura de arquivo, contagem de linhas/palavras/caracteres e envio via POST

## Status dos desafios

- `Desafio 1`: implementado em [bash/inventario-sistema.sh](/home/paulo/elven/devops-journey/fase-1-fundacao/bash/inventario-sistema.sh:1)
- `Desafio 2`: parcialmente atendido; ainda depende de abrir PR `develop -> main`, fazer merge e fechar o minimo de 5 commits
- `Desafio 3`: implementado em [bash/diagnostico-rede.sh](/home/paulo/elven/devops-journey/fase-1-fundacao/bash/diagnostico-rede.sh:1)
- `Desafio 4`: documentado em [linux/acesso-ssh.md](/home/paulo/elven/devops-journey/fase-1-fundacao/linux/acesso-ssh.md:1), mas a aplicacao no servidor/VM continua sendo manual
- `Desafio 5`: implementado em [python/script-api.py](/home/paulo/elven/devops-journey/fase-1-fundacao/python/script-api.py:1)

## Desafio 1 - Inventario do sistema

O script coleta:

- IP da maquina
- uso de CPU
- uso de memoria
- uso de disco
- usuarios logados

Tambem grava a saida em arquivo de log com data no nome.

### Como executar

```bash
bash fase-1-fundacao/bash/inventario-sistema.sh
```

## Desafio 3 - Diagnostico de rede

O script gera um relatorio `.txt` com timestamp contendo:

- resolucao DNS de `google.com`, `github.com` e `httpbin.org`
- teste HTTP com `curl`
- lista de portas abertas na maquina

### Como executar

```bash
bash fase-1-fundacao/bash/diagnostico-rede.sh
```

## nip.io e /etc/hosts

### Sobre nip.io

`nip.io` e um servico DNS wildcard que resolve nomes no formato `<ip>.nip.io` para o proprio IP.

Exemplo:

```text
192.168.31.79.nip.io
```

### Sobre /etc/hosts

`/etc/hosts` permite mapear nomes localmente sem depender de DNS externo.

Exemplo:

```text
192.168.31.79 minha-app.local
```

## Desafio 4 - Acesso SSH seguro

Os passos para configurar autenticacao por chave, testar o acesso e desabilitar senha no `sshd_config` estao documentados em [linux/acesso-ssh.md](/home/paulo/elven/devops-journey/fase-1-fundacao/linux/acesso-ssh.md:1).

## Desafio 5 - Automacao com Python

O script:

- le um arquivo texto
- conta linhas, palavras e caracteres
- envia o resumo para uma API publica via `POST`

### Como executar

```bash
python3 fase-1-fundacao/python/script-api.py fase-1-fundacao/python/exemplo.txt
```

### Exemplo de destino alternativo

```bash
python3 fase-1-fundacao/python/script-api.py fase-1-fundacao/python/exemplo.txt https://httpbin.org/post
```

## Pendencias para encerrar a fase 1

- criar pelo menos mais 1 commit organizado para fechar o minimo de 5 commits
- abrir um Pull Request de `develop` para `main` no GitHub
- fazer o merge desse Pull Request
- aplicar o desafio de SSH em uma VM ou servidor real e validar login sem senha
