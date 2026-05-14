#!/bin/bash

set -u

TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
REPORT_FILE="relatorio-rede_${TIMESTAMP}.txt"
DOMAINS=("google.com" "github.com" "httpbin.org")

resolve_dns() {
    local domain="$1"

    if command -v dig >/dev/null 2>&1; then
        dig +short "$domain" | sed '/^$/d'
        return
    fi

    if command -v host >/dev/null 2>&1; then
        host "$domain" 2>/dev/null | awk '/has address/ {print $4}'
        return
    fi

    if command -v nslookup >/dev/null 2>&1; then
        nslookup "$domain" 2>/dev/null | awk '/^Address: / {print $2}'
        return
    fi

    echo "Nenhuma ferramenta de DNS disponivel (dig, host ou nslookup)."
}

check_http() {
    local domain="$1"
    curl -o /dev/null -sS -L \
        --connect-timeout 5 \
        --max-time 10 \
        -w "HTTP %{http_code} | IP %{remote_ip} | Tempo %{time_total}s\n" \
        "https://${domain}" 2>&1
}

list_open_ports() {
    if command -v ss >/dev/null 2>&1; then
        ss -tuln
        return
    fi

    if command -v netstat >/dev/null 2>&1; then
        netstat -tuln
        return
    fi

    echo "Nenhuma ferramenta para listar portas disponivel (ss ou netstat)."
}

generate_report() {
    {
        echo "========================================"
        echo "RELATORIO DE DIAGNOSTICO DE REDE"
        echo "Gerado em: $(date +'%d/%m/%Y %H:%M:%S')"
        echo "Hostname: $(hostname 2>/dev/null || echo 'indisponivel')"
        echo "========================================"
        echo
        echo "1. RESOLUCAO DNS"

        for domain in "${DOMAINS[@]}"; do
            echo "Dominio: ${domain}"
            dns_result="$(resolve_dns "$domain")"

            if [ -n "$dns_result" ]; then
                echo "$dns_result"
            else
                echo "Nenhum IP retornado."
            fi

            echo
        done

        echo "2. TESTE DE CONECTIVIDADE HTTP"

        for domain in "${DOMAINS[@]}"; do
            echo "URL: https://${domain}"
            check_http "$domain"
            echo
        done

        echo "3. PORTAS ABERTAS NA MAQUINA"
        list_open_ports
        echo
    } | tee "$REPORT_FILE"

    echo "Relatorio salvo em: $REPORT_FILE"
}

generate_report
