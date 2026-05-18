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

### Pre-requisitos

- estar na raiz do repositorio `devops-journey`
- ter `python3` instalado
- ter acesso a internet para validar o `POST` no `httpbin`

### Passo a passo para executar

1. Entrar na raiz do repositorio:

```bash
cd /home/paulo/elven/devops-journey
```

2. Validar se o Python 3 esta disponivel:

```bash
python3 --version
```

3. Conferir os arquivos do desafio:

```bash
ls fase-1-fundacao/python/
```

4. Executar o script com o arquivo de exemplo:

```bash
python3 fase-1-fundacao/python/script-api.py fase-1-fundacao/python/exemplo.txt
```

5. Observar a saida no terminal:

- resumo do arquivo em JSON
- quantidade de linhas, palavras e caracteres
- envio para `https://httpbin.org/post`
- codigo de resposta HTTP

### Como executar

```bash
python3 fase-1-fundacao/python/script-api.py fase-1-fundacao/python/exemplo.txt
```

### Exemplo de destino alternativo

```bash
python3 fase-1-fundacao/python/script-api.py fase-1-fundacao/python/exemplo.txt https://httpbin.org/post
```

### Resultado esperado com o arquivo de exemplo

Para o arquivo [python/exemplo.txt](/home/paulo/elven/devops-journey/fase-1-fundacao/python/exemplo.txt:1), o resumo esperado e:

```json
{
  "arquivo": "exemplo.txt",
  "linhas": 3,
  "palavras": 20,
  "caracteres": 133
}
```

Se a rede estiver disponivel, a execucao deve exibir tambem:

```text
Enviando resultado para: https://httpbin.org/post
Resposta HTTP: 200
```

### Como apresentar

Voce pode explicar a execucao desta forma:

1. o script le um arquivo texto local
2. conta linhas, palavras e caracteres
3. monta um JSON com esse resumo
4. envia o JSON para uma API publica usando `POST`
5. imprime a resposta HTTP para comprovar o envio

### Observacao sobre ambiente restrito

Se o ambiente estiver sem internet ou com rede bloqueada, a parte de leitura e contagem ainda funciona normalmente, mas o envio via `POST` pode falhar por falta de conectividade.

