#!/bin/bash
# healthcheck.sh — Monitor de estado de servicios
# NovaTech Solutions — Equipo de Infraestructura

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_service() {
  local name=$1
  local container=$2
  local status
  status=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null || echo "not_found")

  if [ "$status" = "running" ]; then
    echo -e "  ${GREEN}✓${NC} ${name}: running"
  else
    echo -e "  ${RED}✗${NC} ${name}: ${status}"
  fi
}

echo ""
echo "=== NovaTech Service Health Check ==="
echo "  $(date)"
echo ""

check_service "App (PulseTrack)" "novatech-deploy-app-1"
check_service "PostgreSQL"        "novatech-deploy-db-1"
check_service "Redis"             "novatech-deploy-redis-1"
check_service "Nginx"             "novatech-deploy-nginx-1"

echo ""

# HTTP check
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health 2>/dev/null || echo "000")
if [ "$HTTP_STATUS" = "200" ]; then
  echo -e "  ${GREEN}✓${NC} HTTP endpoint: OK (${HTTP_STATUS})"
else
  echo -e "  ${YELLOW}⚠${NC} HTTP endpoint: ${HTTP_STATUS}"
fi

echo ""
