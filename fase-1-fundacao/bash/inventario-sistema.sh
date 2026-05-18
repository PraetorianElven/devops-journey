#!/bin/bash

LOG_FILE="monitoramento_$(date +'%Y-%m-%d').log"

coletar_dados() {
    echo "----------------------------------------------------"
    echo "Relatório de Sistema - $(date +'%d/%m/%Y %H:%M:%S')"
    echo "----------------------------------------------------"

    # IP da Máquina
    echo "Endereço IP:"
    IP_ADDRESS="$(hostname -I 2>/dev/null | awk '{print $1}')"
    echo "${IP_ADDRESS:-indisponivel}"
    echo ""

    # CPU
    echo "CPU:"

    CPU_MODEL=$(lscpu | awk -F: '/Model name|Nome do modelo/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')
    CPU_CORES=$(nproc)
    CPU_FREQ=$(lscpu | awk -F: '/CPU max MHz|CPU MHz|MHz máx/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')

    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle1=$((idle + iowait))

    sleep 1

    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle2=$((idle + iowait))

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))

    CPU_TOTAL=$(awk "BEGIN {printf \"%.2f\", (100 * ($total_diff - $idle_diff) / $total_diff)}")
    LOAD_AVG=$(uptime | awk -F'load average:|média de carga:' '{print $2}')

    echo "Modelo: ${CPU_MODEL:-N/A}"
    echo "vCPUs: $CPU_CORES"
    echo "Frequência Atual: ${CPU_FREQ:-N/A} MHz"
    echo "Uso Total: ${CPU_TOTAL}%"
    echo "Load Average:${LOAD_AVG}"
    echo ""

    # Top processos por CPU
    echo "Top 5 processos por CPU:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
    echo ""

    # Memória
    echo "Uso de Memória:"
    free -m | awk 'NR==2 {
        printf "Total: %.2fGB | Usado: %.2fGB | Livre: %.2fGB | Buff/Cache: %.2fGB\n",
        $2/1024, $3/1024, $4/1024, $6/1024
    }'
    echo ""

    # Disco
    echo "Uso de Disco (Partição Raiz):"
    df -h / | awk 'NR==2 {
        print "Total: "$2 " | Usado: "$3 " | Livre: "$4 " ("$5")"
    }'
    echo ""

    # Usuários logados
    echo "Usuários Logados:"
    who

    echo "----------------------------------------------------"
    echo ""
}

coletar_dados | tee -a "$LOG_FILE"
