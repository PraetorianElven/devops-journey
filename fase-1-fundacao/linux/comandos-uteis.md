# linux/comandos-uteis.md

# Comandos Úteis Linux — Cheatsheet Pessoal

## Navegação entre diretórios

```bash
pwd                 # Mostra diretório atual
ls                  # Lista arquivos
ls -la              # Lista incluindo ocultos e permissões
cd /caminho         # Entra em diretório
cd ..               # Volta um nível
cd ~                # Vai para home
tree                # Exibe estrutura de pastas

#Manipulação de arquivos e diretórios
touch arquivo.txt               # Cria arquivo
mkdir pasta                     # Cria diretório
mkdir -p pasta/subpasta         # Cria estrutura completa
cp origem destino               # Copia arquivo
cp -r pasta1 pasta2             # Copia diretório
mv origem destino               # Move ou renomeia
rm arquivo                      # Remove arquivo
rm -rf pasta                    # Remove pasta recursivamente
cat arquivo.txt                 # Exibe conteúdo
less arquivo.txt                # Visualização paginada
head -n 10 arquivo.txt          # Primeiras 10 linhas
tail -n 10 arquivo.txt          # Últimas 10 linhas
tail -f log.txt                 # Acompanha log em tempo real

#Busca
find / -name arquivo.txt        # Busca por nome
find . -type f                  # Busca arquivos
grep "texto" arquivo.txt        # Busca texto
grep -r "texto" .               # Busca recursiva
which comando                   # Caminho do comando
whereis comando                 # Localiza binário/doc

#Processos
ps aux                          # Lista processos
top                             # Monitor em tempo real
htop                            # Versão melhorada
kill PID                        # Mata processo
kill -9 PID                     # Força encerramento
pgrep nome                      # Busca PID
pkill nome                      # Mata por nome

#Sistema
uname -a                        # Info kernel
hostname                        # Nome da máquina
hostname -I                     # IP local
uptime                          # Tempo ligado
df -h                           # Disco
du -sh pasta                    # Tamanho da pasta
free -h                         # Memória
lscpu                           # CPU
lsblk                           # Discos

#Rede
ip a                            # Interfaces/IP
ping google.com                 # Teste conectividade
curl ifconfig.me                # IP público
curl -I google.com              # Cabeçalho HTTP
ss -tulnp                       # Portas abertas
netstat -tulnp                  # Portas (legado)
dig google.com                  # DNS
nslookup google.com             # DNS

#SSH
ssh usuario@ip                  # Conectar
scp arquivo usuario@ip:/dest   # Copiar arquivo
ssh-keygen                      # Gerar chave
ssh-copy-id usuario@ip          # Copiar chave
Pacotes (Debian/Ubuntu)
sudo apt update
sudo apt upgrade
sudo apt install pacote
sudo apt remove pacote

#Logs
journalctl -xe                  # Logs systemd
systemctl status ssh            # Status serviço
systemctl restart ssh           # Reinicia

#Git básico
git init
git status
git add .
git commit -m "mensagem"
git push
git pull