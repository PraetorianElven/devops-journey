# Fase 1 - Fundacao

## Desafio 3 - Diagnostico de rede

O script [bash/diagnostico-rede.sh](/home/paulo/elven/devops-journey/fase-1-fundacao/bash/diagnostico-rede.sh:1) foi criado para coletar informacoes basicas de diagnostico de rede e salvar o resultado em um relatorio `.txt` com timestamp.

### O que o script faz

- Resolve DNS de 3 dominios: `google.com`, `github.com` e `httpbin.org`
- Testa conectividade HTTP com `curl`
- Lista portas abertas na maquina com `ss` ou `netstat`
- Salva tudo em um arquivo no formato `relatorio-rede_YYYY-MM-DD_HH-MM-SS.txt`

### Como executar

```bash
bash fase-1-fundacao/bash/diagnostico-rede.sh
```

### Saida esperada

Ao executar, o script:

- exibe o resultado no terminal;
- gera um arquivo `.txt` com data e hora;
- registra DNS, resposta HTTP e portas abertas.

## nip.io e /etc/hosts

### Sobre nip.io

O `nip.io` e um servico DNS wildcard gratuito que mapeia qualquer endereco IP para um nome de host, facilitando desenvolvimento local e testes.

Exemplo:

```text
192.168.31.79.nip.io
```

Esse nome resolve automaticamente para:

```text
192.168.31.79
```

Isso ajuda em labs, Kubernetes, Ingress e testes locais sem precisar comprar dominio nem editar DNS a cada projeto.

### Sobre /etc/hosts

O `/etc/hosts` e um arquivo local do Linux que associa IPs a nomes manualmente.

Formato:

```text
IP nome aliases
```

Exemplo:

```text
192.168.31.79 minha-app.local
```

Assim, sua maquina resolve `minha-app.local` para `192.168.31.79` sem depender de DNS externo.
