#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AWSLOCAL="$ROOT_DIR/bin/awslocal.sh"
BUCKET_NAME="${1:-devops-journey-lab}"

echo "Removendo objetos do bucket de bootstrap: $BUCKET_NAME"
"$AWSLOCAL" s3 rm "s3://$BUCKET_NAME" --recursive >/dev/null 2>&1 || true

echo "Removendo bucket de bootstrap: $BUCKET_NAME"
"$AWSLOCAL" s3 rb "s3://$BUCKET_NAME" >/dev/null 2>&1 || true

echo "Buckets restantes:"
"$AWSLOCAL" s3 ls || true
