
# Docker with Next.js

Short description of what this project does and who it’s for.

---

## Prerequisites

* **Docker** (Desktop or Engine)
* **Docker Compose v2** (included with modern Docker Desktop; `docker compose` command, not `docker-compose`)

Check versions:

```bash
docker --version
docker compose version
```

---

## Quick Start

Build the image, start the stack in the background, and verify it’s running.

```bash
# 1) Build the application image
# Replace with your Docker Hub (or registry) namespace and a project name
docker build -t <username>/<project-name>:latest .

# 2) Start services with Docker Compose in detached mode
# (Assumes a docker-compose.yml at the repo root)
docker compose up -d

# 3) See running containers/services
docker compose ps
```

> **Tip:** If you’re on Windows PowerShell, the commands are the same.

---

## Common Tasks

### View logs

```bash
docker compose logs -f
# or logs for a single service
docker compose logs -f <service-name>
```

### Stop services

```bash
docker compose down
```

### Stop and remove volumes (⚠️ deletes data)

```bash
docker compose down -v
```

### Rebuild after code changes

```bash
# Rebuild the image (no cache)
docker build --no-cache -t <username>/<project-name>:latest .

# Recreate containers with the new image
docker compose up -d --build
```

### Open a shell inside a running service container

```bash
docker compose exec <service-name> sh
# or bash if available
# docker compose exec <service-name> bash
```

### List images/containers

```bash
docker images
docker ps -a
```

---

## Configuration

Most projects use environment variables. Create a `.env` file at the repository root (same folder as `docker-compose.yml`). Compose automatically loads it.

**.env example:**

```env
# App
APP_ENV=production
APP_PORT=8080

# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=app
POSTGRES_PORT=5432
```

> **Note:** Reference these variables in `docker-compose.yml` like `${APP_PORT}`.

---

## Example docker-compose.yml

> Adjust service names, ports, and volumes to your stack.

```yaml
services:
  app:
    image: ${REGISTRY_IMAGE:-<username>/<project-name>:latest}
    # Or build locally instead of using a prebuilt image:
    # build: .
    ports:
      - "${APP_PORT:-8080}:8080"
    env_file: .env
    depends_on:
      - db

  db:
    image: postgres:16
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-postgres}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-postgres}
      POSTGRES_DB: ${POSTGRES_DB:-app}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

Then run:

```bash
docker compose up -d
```

---

## Tagging & Pushing to a Registry

```bash
# Tag explicitly for clarity
docker tag <username>/<project-name>:latest <username>/<project-name>:v1.0.0

# Login and push
docker login
docker push <username>/<project-name>:latest
docker push <username>/<project-name>:v1.0.0
```

> Replace `<username>` with your Docker Hub/registry namespace. For private registries, use the full registry URL, e.g. `registry.example.com/team/app:tag`.

---

## Directory Structure (example)

```
.
├─ Dockerfile
├─ docker-compose.yml
├─ .env.example
├─ src/
│  ├─ ...
└─ README.md
```

---

## Troubleshooting

* **`Cannot connect to the Docker daemon`**
  * Ensure Docker Desktop/Engine is running. On Linux, you may need to run with `sudo` or add your user to the `docker` group.
* **Ports already in use**
  * Change published ports in `docker-compose.yml` (left side of `host:container`), or stop the process using that port.
* **`docker compose` vs `docker-compose`**
  * Modern setups use `docker compose` (a Docker CLI plugin). If you only have `docker-compose`, update Docker or adapt commands accordingly.
* **Containers crash-looping**
  * Inspect logs: `docker compose logs -f <service-name>`
  * Enter the container: `docker compose exec <service-name> sh`
* **Rebuilding changes not reflected**
  * Use `--no-cache` on `docker build` and `--build` on `docker compose up`.

---

## Makefile (optional)

You can wrap common commands for convenience.

```makefile
.PHONY: build up down logs ps shell

IMAGE ?= <username>/<project-name>

build:
	docker build -t $(IMAGE):latest .

up:
	docker compose up -d

ps:
	docker compose ps

logs:
	docker compose logs -f

shell:
	docker compose exec app sh

down:
	docker compose down
```

---

## License

Choose a license and place it in `LICENSE`.

---

## Contributing

Pull requests welcome! Please open an issue first to discuss major changes.

---

## Notes

* Replace all `<username>/<project-name>` placeholders with your image name.
* Keep your `.env` values secure; don’t commit secrets.
