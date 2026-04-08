# novatech-deploy

Scripts de despliegue e infraestructura interna para los servicios de NovaTech Solutions.

## Estructura

```
novatech-deploy/
├── deploy.sh           # Script principal de despliegue
├── docker-compose.yml  # Servicios en contenedor
├── Makefile            # Comandos de gestión
├── .env.example        # Plantilla de variables de entorno
└── scripts/
    ├── backup.sh       # Backup automatizado de bases de datos
    └── healthcheck.sh  # Monitor de estado de servicios
```

## Requisitos

- Docker 24.x
- Docker Compose v2
- Bash 5.x
- Acceso SSH a los servidores de producción

## Uso rápido

```bash
cp .env.example .env
# Editar .env con las credenciales correctas
make deploy
```

## Entornos

| Entorno     | Host                        | Puerto |
|-------------|-----------------------------|--------|
| Production  | prod.novatech.internal      | 443    |
| Staging     | staging.novatech.internal   | 8443   |
| Development | localhost                   | 3000   |

## Equipo

Mantenido por el equipo de infraestructura de NovaTech Solutions.  
Contacto interno: infra@novatech.internal
