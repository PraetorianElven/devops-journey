# nip.io e /etc/hosts

# Sobre nip.io

O nip.io é um serviço DNS "wildcard" gratuito que mapeia qualquer endereço IP para um nome de host, facilitando o desenvolvimento local e testes ao transformar IPs(como 127.0.0.1) em domínios (127.0.0.1.nip.io). Ele elimina a necessidade de editar o arquivo hosts para cada projeto, permitindo subdomínios dinâmicos.

nip.io é um serviço de DNS wildcard. Ele transforma um IP dentro do nome em um DNS válido. Exemplo: 192.168.31.79.nip.io resolve para 192.168.31.79. Isso ajuda em labs, Kubernetes, Ingress e testes locais sem precisar comprar domínio.

# Sobre /etc/hosts

O /etc/hosts é um arquivo local do Linux que associa IPs a nomes. O formato é:

IP nome aliases

Exemplo:

192.168.31.79 minha-app.local

Assim, sua máquina resolve minha-app.local para 192.168.31.79 sem depender de DNS externo.