#!/bin/bash
# deploy.sh — Script principal de despliegue
# NovaTech Solutions — Equipo de Infraestructura
# Autores: infra-team@novatech.internal

set -euo pipefail

ENVIRONMENT="${1:-production}"
COMPOSE_FILE="docker-compose.yml"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   NovaTech Deploy Script v2.1        ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Validaciones
if [ ! -f ".env" ]; then
  echo "[ERROR] Archivo .env no encontrado."
  echo "        Ejecuta: cp .env.example .env"
  exit 1
fi

if ! command -v docker &>/dev/null; then
  echo "[ERROR] Docker no está instalado."
  exit 1
fi

echo "[*] Entorno: ${ENVIRONMENT}"
echo "[*] Tirando imágenes actualizadas..."
docker compose -f "$COMPOSE_FILE" pull --quiet

echo "[*] Levantando servicios..."
docker compose -f "$COMPOSE_FILE" up -d --remove-orphans

echo "[*] Esperando que los servicios estén listos..."
sleep 5

bash scripts/healthcheck.sh

echo ""
echo "[+] Despliegue en ${ENVIRONMENT} completado."
echo ""
