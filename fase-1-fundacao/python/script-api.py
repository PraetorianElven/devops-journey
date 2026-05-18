#!/usr/bin/env python3

"""Conta palavras, linhas e caracteres de um arquivo e envia o resultado via POST."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from urllib import error, request

DEFAULT_URL = "https://httpbin.org/post"


def count_text(text: str) -> dict[str, int]:
    return {
        "linhas": len(text.splitlines()),
        "palavras": len(text.split()),
        "caracteres": len(text),
    }


def build_payload(file_path: Path) -> dict[str, object]:
    text = file_path.read_text(encoding="utf-8")
    counts = count_text(text)

    return {
        "arquivo": file_path.name,
        "caminho": str(file_path.resolve()),
        **counts,
    }


def post_payload(url: str, payload: dict[str, object]) -> tuple[int, str]:
    data = json.dumps(payload).encode("utf-8")
    headers = {"Content-Type": "application/json"}
    http_request = request.Request(url, data=data, headers=headers, method="POST")

    with request.urlopen(http_request, timeout=10) as response:
        body = response.read().decode("utf-8", errors="replace")
        return response.status, body


def main() -> int:
    if len(sys.argv) < 2:
        print(
            "Uso: python3 script-api.py <arquivo.txt> [url_api]",
            file=sys.stderr,
        )
        return 1

    file_path = Path(sys.argv[1]).expanduser()
    target_url = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_URL

    if not file_path.is_file():
        print(f"Arquivo nao encontrado: {file_path}", file=sys.stderr)
        return 1

    try:
        payload = build_payload(file_path)
    except OSError as exc:
        print(f"Falha ao ler arquivo: {exc}", file=sys.stderr)
        return 1

    print("Resumo do arquivo:")
    print(json.dumps(payload, indent=2, ensure_ascii=True))
    print(f"Enviando resultado para: {target_url}")

    try:
        status_code, response_body = post_payload(target_url, payload)
    except error.URLError as exc:
        print(f"Falha ao enviar requisicao: {exc}", file=sys.stderr)
        return 2

    print(f"Resposta HTTP: {status_code}")
    print(response_body)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
