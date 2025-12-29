#!/bin/bash
set -euo pipefail

if [ -z "${DOMAIN_NAME:-}" ]; then
	echo "DOMAIN_NAME must be defined." >&2
	exit 1
fi

export DOMAIN_NAME


CERT_DIR="/etc/nginx/certs/${DOMAIN_NAME}"
CERT_FILE="${CERT_DIR}/cert.pem"
KEY_FILE="${CERT_DIR}/key.pem"

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
	echo "Generating self-signed certificate for $DOMAIN_NAME"
	mkdir -p "$CERT_DIR"
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout "$KEY_FILE" \
		-out "$CERT_FILE" \
		-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Student/CN=${DOMAIN_NAME}"
fi

envsubst '$DOMAIN_NAME' < /etc/nginx/templates/default.conf.tpl > /etc/nginx/conf.d/default.conf

exec "$@"
