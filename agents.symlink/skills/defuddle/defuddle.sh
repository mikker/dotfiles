#!/usr/bin/env bash
set -euo pipefail

if [ "${1-}" = "" ]; then
  echo "Usage: defuddle.sh <url>" >&2
  exit 1
fi

url="$1"

case "$url" in
  http://*|https://*) ;;
  *)
    echo "Error: URL must start with http:// or https://" >&2
    exit 1
    ;;
esac

exec npx -y defuddle parse --markdown "$url"
