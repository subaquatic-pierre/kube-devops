# Project Deploy Template

A multi-environment deployment template for full-stack projects. Use this as a starting point for any new project that needs:

- **Local development** with Docker Compose (hot-reload)
- **Staging** deployment to Kubernetes
- **Production** deployment to bare-metal / VMs via SystemD-managed Docker containers

## Architecture

```
┌──────────────┐     ┌─────────────┐
│   Frontend   │────▶│     API     │
│  Next.js +   │     │  FastAPI +  │
│  shadcn/ui   │     │  SQLAlchemy │
└──────────────┘     └─────────────┘
       │                    │
       │              ┌─────┴──────┐
       │              │  SQLite /  │
       │              │ PostgreSQL │
       │              └────────────┘
       │
       ▼
  Port 4000          Port 5000
```

| Service      | Directory | Stack                               |
| ------------ | --------- | ----------------------------------- |
| **API**      | `./api`   | Python FastAPI + SQLAlchemy         |
| **Frontend** | `./www`   | Next.js 15 + TypeScript + shadcn/ui |

## Quick Start (Local Development)

```bash
# 1. Start all services
docker compose up

# 2. Open the frontend:
#    → http://localhost:4000
#    The landing page includes a Live Demo section that talks to the API.

# 3. API docs:
#    Swagger UI: http://localhost:5000/docs
#    ReDoc:      http://localhost:5000/redoc
```

## API Endpoints

The FastAPI backend provides a simple CRUD for items:

| Method | Endpoint      | Description    |
| ------ | ------------- | -------------- |
| GET    | `/items`      | List all items |
| GET    | `/items/{id}` | Get an item    |
| POST   | `/items`      | Create an item |
| PUT    | `/items/{id}` | Update an item |
| DELETE | `/items/{id}` | Delete an item |
| GET    | `/health`     | Health check   |

Example: `curl -X POST http://localhost:5000/items -H "Content-Type: application/json" -d '{"title":"Hello","description":"World"}'`

## Frontend ↔ Backend Integration

The frontend (`www`) communicates with the backend (`api`) over HTTP. In development, the frontend runs on port 4000 and the backend on port 5000.

### How it works

1. The frontend uses `NEXT_PUBLIC_API_URL` (set in `www/.env`) as the base URL for all API calls
2. An API client module at `www/lib/api.ts` provides typed functions (`listItems`, `createItem`, etc.)
3. The landing page's **Live Demo** section (`components/demo-section.tsx`) demonstrates full CRUD interactivity:
   - Shows API connection status (health check)
   - Lists existing items from the backend
   - Create new items via inline form
   - Delete items with a single click
4. The backend uses `CORSMiddleware` (configured in `api/main.py`) to allow cross-origin requests from the frontend

### In development

The frontend dev server (`next dev`) proxies API requests directly to the URL specified in `NEXT_PUBLIC_API_URL`. Hot-reload works for both services independently.

### In production/staging

Build-time args (`NEXT_PUBLIC_API_URL`) are passed to the Docker build so the built frontend knows where to find the API. See `Dockerfile.staging` and `Dockerfile.prod` for details.

## Deployment

The `deploy.sh` script handles building, pushing, and deploying to any target.

```bash
# Deploy locally (build images, apply Kubernetes manifests)
./deploy.sh 1.0.0 local

# Deploy to staging (build, push, remote kubectl apply)
./deploy.sh 1.0.0 staging

# Deploy to production (build, push, remote systemd update)
./deploy.sh 1.0.0 production
```

See `./deploy.sh help` for full usage.

## Deployment Strategies

| Environment    | Orchestration    | Image Source  |
| -------------- | ---------------- | ------------- |
| **Local**      | Docker Compose   | Local build   |
| **Staging**    | Kubernetes       | Registry push |
| **Production** | SystemD + Docker | Registry pull |

### Local

Uses `docker-compose.yml` with host-mounted volumes for hot-reloading.

- **API**: `uvicorn` runs with `--reload` — changes to `./api/*.py` auto-restart
- **Frontend**: `next dev` — changes to `./www/*` hot-reload instantly

### Staging

Images are built with `Dockerfile.staging`, pushed to a container registry, and deployed to a remote Kubernetes cluster via SSH + `kubectl apply`.

### Production

Images are built with `Dockerfile.prod`, pushed to a registry, and rolled out to one or more production hosts via SystemD service units. Each host runs:

- `api.service` — the backend (Python FastAPI)
- `www.service` — the frontend (Next.js)

SystemD handles container lifecycle (restart, logging via journald, graceful shutdown).

## Customizing for Your Project

1. **Replace `./api` and `./www`** with your own backend and frontend code.
2. **Update Dockerfiles** — ensure `Dockerfile.dev`, `Dockerfile.staging`, and `Dockerfile.prod` exist in each service directory.
3. **Set remote hosts** — edit `deploy.sh` to set your `STAGING_HOST`, `PRODUCTION_HOST_1`, `PRODUCTION_HOST_2`.
4. **Configure SSH** — update `config/ssh_config` with your host IPs and keys.
5. **Adjust SystemD units** — tweak `config/api.service` and `config/www.service` as needed (memory limits, env files, etc.).
6. **Edit Kubernetes manifests** in `./kubernetes/` — update image names, set your registry secret, adjust replica counts, etc.
