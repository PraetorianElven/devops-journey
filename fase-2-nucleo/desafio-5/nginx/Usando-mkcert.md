# Documentacao do mkcert no Projeto

## Objetivo

Este projeto usa o `mkcert` para criar certificados TLS locais confiaveis no ambiente de desenvolvimento. A ideia e simples:

- o navegador acessa `https://app1.local` ou `https://app2.local`
- o `nginx` recebe a conexao HTTPS
- o `nginx` usa um certificado gerado localmente pelo `mkcert`
- depois ele faz proxy para as aplicacoes Flask rodando em HTTP dentro da rede Docker

Isso permite testar HTTPS localmente sem alerta de certificado invalido, desde que a CA local do `mkcert` tenha sido instalada na maquina host.

## O que e o mkcert

O `mkcert` e uma ferramenta para gerar certificados locais assinados por uma autoridade certificadora criada na sua propria maquina.

Na pratica, ele faz duas coisas:

1. Cria uma CA local de desenvolvimento.
2. Instala essa CA no armazenamento de confianca do seu sistema e navegador.

Depois disso, qualquer certificado gerado por essa CA passa a ser confiavel no seu ambiente local.

Analogia simples: em vez de comprar um cracha oficial de uma empresa externa, voce cria um cracha local que a sua propria maquina reconhece como valido para testes.

## Como o fluxo funciona

Quando voce executa:

```bash
mkcert -install
```

o `mkcert` registra a CA local no host.

Quando voce executa:

```bash
mkcert app1.local app2.local
```

ele gera um certificado com SANs para os dois dominios:

- `app1.local`
- `app2.local`

Os arquivos gerados normalmente ficam assim:

- `app1.local+1.pem`
- `app1.local+1-key.pem`

O `+1` aparece porque o mesmo certificado cobre mais de um nome DNS.

## Como isso foi aplicado neste projeto

### 1. Certificados gerados dentro da pasta `nginx/`

Os arquivos de certificado precisam ficar dentro de:

[`nginx/`](/home/paulo/elven/devops-journey/fase-2-nucleo/desafio-5/nginx)

Arquivos esperados:

- `app1.local+1.pem`
- `app1.local+1-key.pem`

Esses arquivos sao lidos pelo container do `nginx` via volume do Docker Compose.

### 2. Volume do Docker Compose

No arquivo [docker-compose.yml](/home/paulo/elven/devops-journey/fase-2-nucleo/desafio-5/docker-compose.yml), o servico `nginx` monta a pasta local `./nginx` dentro do container em `/etc/nginx/certs`:

```yaml
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx:/etc/nginx/certs:ro
```

Na pratica:

- `./nginx/app1.local+1.pem` no host vira `/etc/nginx/certs/app1.local+1.pem` no container
- `./nginx/app1.local+1-key.pem` no host vira `/etc/nginx/certs/app1.local+1-key.pem` no container

### 3. Configuracao do Nginx

No arquivo [nginx.conf](/home/paulo/elven/devops-journey/fase-2-nucleo/desafio-5/nginx/nginx.conf), existem dois blocos HTTPS, um para cada dominio:

```nginx
server {
    listen 443 ssl;
    server_name app1.local;

    ssl_certificate /etc/nginx/certs/app1.local+1.pem;
    ssl_certificate_key /etc/nginx/certs/app1.local+1-key.pem;

    location / {
        proxy_pass http://app1:5000;
    }
}

server {
    listen 443 ssl;
    server_name app2.local;

    ssl_certificate /etc/nginx/certs/app1.local+1.pem;
    ssl_certificate_key /etc/nginx/certs/app1.local+1-key.pem;

    location / {
        proxy_pass http://app2:5000;
    }
}
```

O mesmo certificado e reutilizado para `app1.local` e `app2.local` porque ele foi emitido com ambos os dominios no comando do `mkcert`.

### 4. Redirecionamento HTTP para HTTPS

Ainda no `nginx.conf`, as portas HTTP redirecionam para HTTPS:

```nginx
server {
    listen 80;
    server_name app1.local;
    return 301 https://$host$request_uri;
}

server {
    listen 80;
    server_name app2.local;
    return 301 https://$host$request_uri;
}
```

Isso faz com que qualquer acesso em `http://app1.local` ou `http://app2.local` seja automaticamente enviado para a versao segura.

## Arquitetura da solucao

```text
Navegador
  -> HTTPS (443)
Nginx
  -> HTTP interno Docker
app1:5000 ou app2:5000
```

O TLS termina no `nginx`. As aplicacoes Flask nao precisam servir HTTPS diretamente.

## Passo a passo para usar no projeto

## Passo a passo para implantar o mkcert neste projeto

Esta e a sequencia recomendada para implantar HTTPS local com `mkcert` neste repositorio.

### 1. Instalar o mkcert

Instale o binario do `mkcert` na sua maquina host. O metodo exato depende do sistema operacional.

Depois confirme que o comando esta disponivel:

```bash
mkcert --version
```

### 2. Instalar a CA local do mkcert no host

Execute:

```bash
mkcert -install
```

Esse passo cria ou reaproveita a autoridade certificadora local e registra essa CA no sistema operacional para que o navegador passe a confiar nos certificados gerados por ela.

Sem esse passo, o navegador tende a mostrar erros como:

- `ERR_CERT_AUTHORITY_INVALID`
- `Sua conexao nao e particular`

### 3. Configurar os dominios locais no host

Edite o arquivo `/etc/hosts` e garanta a presenca destas entradas:

```text
127.0.0.1 app1.local
127.0.0.1 app2.local
```

Isso faz com que os dominios resolvam para a sua maquina local.

### 4. Gerar os certificados dentro da pasta `nginx`

Entre na pasta:

```bash
cd /home/paulo/elven/devops-journey/fase-2-nucleo/desafio-5/nginx
```

Gere os certificados:

```bash
mkcert app1.local app2.local
```

Esse comando gera um unico certificado valido para os dois dominios do projeto.

Arquivos esperados:

- `app1.local+1.pem`
- `app1.local+1-key.pem`

### 5. Subir ou reiniciar os containers

Se os containers ainda nao estiverem rodando:

Na raiz do projeto:

```bash
docker compose up -d --build
```

Se eles ja estiverem rodando e voce apenas trocou o certificado:

```bash
docker compose restart nginx
```

Se quiser reconstruir tudo:

```bash
docker compose down
docker compose up -d --build
```

### 6. Testar no navegador

Acessos esperados:

- `https://app1.local`
- `https://app2.local`

Se o navegador ainda mostrar o certificado antigo, feche e abra o navegador novamente.

## Como validar

Voce pode validar de tres formas:

1. Verificar se o container `nginx` subiu sem encerrar.
2. Validar a configuracao dentro do container:

```bash
docker exec nginx nginx -t
```

3. Testar o endpoint:

```bash
curl -k -H 'Host: app1.local' https://127.0.0.1
curl -k -H 'Host: app2.local' https://127.0.0.1
```

Observacao: com `curl`, o `-k` ignora validacao de CA. No navegador, o ideal e confiar normalmente no certificado emitido pelo `mkcert`.

## Problemas comuns

### O Nginx morre ao iniciar

Causas mais comuns:

- arquivo `.pem` nao existe na pasta `nginx/`
- caminho do certificado no `nginx.conf` esta incorreto
- o volume do Docker Compose nao montou a pasta esperada

### O navegador continua marcando certificado invalido

Normalmente significa um destes cenarios:

- `mkcert -install` nao foi executado no host atual
- o certificado antigo ainda esta em uso no navegador
- o navegador nao esta usando o store de certificados esperado
- o dominio acessado nao bate com o dominio presente no certificado

Acao recomendada:

1. rodar `mkcert -install` novamente
2. regenerar o certificado dentro da pasta `nginx/`
3. executar `docker compose restart nginx`
4. fechar e reabrir o navegador

### O dominio nao resolve

Se `app1.local` ou `app2.local` nao abrirem, verifique o `/etc/hosts`.

## Resumo tecnico

- O `mkcert` gera um certificado local confiavel para desenvolvimento.
- O certificado e criado para `app1.local` e `app2.local`.
- O Docker Compose monta a pasta `nginx/` dentro do container do `nginx`.
- O `nginx` usa esse certificado para atender HTTPS na porta `443`.
- O trafego e encaminhado internamente para `app1:5000` e `app2:5000`.

## Arquivos relacionados

- [docker-compose.yml](/home/paulo/elven/devops-journey/fase-2-nucleo/desafio-5/docker-compose.yml)
- [nginx/nginx.conf](/home/paulo/elven/devops-journey/fase-2-nucleo/desafio-5/nginx/nginx.conf)
- [nginx/Usando-mkcert.md](/home/paulo/elven/devops-journey/fase-2-nucleo/desafio-5/nginx/Usando-mkcert.md)
