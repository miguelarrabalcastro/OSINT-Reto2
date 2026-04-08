.PHONY: deploy stop restart logs backup healthcheck clean

ENV_FILE := .env

check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "ERROR: .env file not found. Run: cp .env.example .env"; \
		exit 1; \
	fi

deploy: check-env
	@echo "[*] Desplegando servicios NovaTech..."
	docker compose pull
	docker compose up -d --remove-orphans
	@echo "[+] Despliegue completado."

stop:
	@echo "[*] Deteniendo servicios..."
	docker compose down
	@echo "[+] Servicios detenidos."

restart: stop deploy

logs:
	docker compose logs -f --tail=100

backup:
	@echo "[*] Iniciando backup..."
	bash scripts/backup.sh
	@echo "[+] Backup completado."

healthcheck:
	bash scripts/healthcheck.sh

clean:
	docker compose down -v --remove-orphans
	docker system prune -f
	@echo "[+] Limpieza completada."
