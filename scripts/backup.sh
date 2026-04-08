#!/bin/bash
# backup.sh — Backup automatizado de PostgreSQL
# NovaTech Solutions — Equipo de Infraestructura

set -euo pipefail

source "$(dirname "$0")/../.env" 2>/dev/null || true

BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="${BACKUP_DIR}/novatech_${TIMESTAMP}.sql.gz"

mkdir -p "$BACKUP_DIR"

echo "[$(date)] Iniciando backup de ${DB_NAME}..."

PGPASSWORD="${DB_PASSWORD}" pg_dump \
  -h "${DB_HOST}" \
  -p "${DB_PORT}" \
  -U "${DB_USER}" \
  -d "${DB_NAME}" \
  --no-password \
  | gzip > "$FILENAME"

SIZE=$(du -sh "$FILENAME" | cut -f1)
echo "[$(date)] Backup completado: ${FILENAME} (${SIZE})"

# Eliminar backups de más de 7 días
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +7 -delete
echo "[$(date)] Limpieza de backups antiguos completada."
