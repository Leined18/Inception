#!/bin/bash
set -euo pipefail

if [ -z "${DOMAIN_NAME:-}" ]; then
	echo "DOMAIN_NAME must be defined." >&2
	exit 1
fi

export DOMAIN_NAME

# NGINX refuses to start without the TLS pair; fail early with a clear message.
if [ ! -f "/etc/nginx/certs/${DOMAIN_NAME}/cert.pem" ] || [ ! -f "/etc/nginx/certs/${DOMAIN_NAME}/key.pem" ]; then
	echo "TLS certificate pair not found under /etc/nginx/certs/${DOMAIN_NAME}." >&2
	exit 1
fi

# Renders the virtual host using the requested domain at runtime.
envsubst '$DOMAIN_NAME' < /etc/nginx/templates/default.conf.tpl > /etc/nginx/conf.d/default.conf

exec "$@"
