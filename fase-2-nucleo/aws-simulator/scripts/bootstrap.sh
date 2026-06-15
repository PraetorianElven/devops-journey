#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AWSLOCAL="$ROOT_DIR/bin/awslocal.sh"
BUCKET_NAME="${1:-devops-journey-lab}"

echo "Validando o endpoint LocalStack..."
"$AWSLOCAL" sts get-caller-identity

echo "Criando bucket de bootstrap: $BUCKET_NAME"
if ! "$AWSLOCAL" s3api head-bucket --bucket "$BUCKET_NAME" >/dev/null 2>&1; then
  "$AWSLOCAL" s3 mb "s3://$BUCKET_NAME"
else
  echo "Bucket ja existe, seguindo."
fi

echo "Buckets disponiveis:"
"$AWSLOCAL" s3 ls
