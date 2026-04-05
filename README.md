# Docker Test Environments

[![Validate](https://github.com/mustafaautomation/docker-test-environments/actions/workflows/validate.yml/badge.svg)](https://github.com/mustafaautomation/docker-test-environments/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED.svg?logo=docker&logoColor=white)](https://docs.docker.com/compose/)

Ready-to-use Docker Compose environments for testing. Spin up databases, caches, mock APIs, and email servers in seconds. Perfect for integration tests and CI pipelines.

---

## Environments

| Environment | Services | Ports | Use Case |
|-------------|----------|-------|----------|
| **postgres** | PostgreSQL 16 + pgAdmin | 5432, 5050 | Database integration tests |
| **full-stack** | PostgreSQL + Redis + WireMock + Mailhog | 5432, 6379, 8080, 8025 | Full integration testing |
| **redis-queue** | Redis 7 + Redis Commander | 6379, 8081 | Queue/cache testing |
| **mongo-api** | MongoDB 7 + Mongo Express | 27017, 8082 | Document DB testing |

---

## Quick Start

```bash
# Start PostgreSQL environment
docker compose -f environments/postgres/docker-compose.yml up -d

# Or use the helper script
./scripts/start.sh postgres

# Stop
docker compose -f environments/postgres/docker-compose.yml down
```

---

## Full-Stack Environment

Includes everything you need for integration testing:

| Service | URL | Purpose |
|---------|-----|---------|
| PostgreSQL | `localhost:5432` | Database |
| Redis | `localhost:6379` | Cache / queues |
| WireMock | `localhost:8080` | Mock external APIs |
| Mailhog | `localhost:8025` | Capture outgoing emails |

```bash
docker compose -f environments/full-stack/docker-compose.yml up -d

# Your tests connect to:
# DATABASE_URL=postgresql://testuser:testpass@localhost:5432/testdb
# REDIS_URL=redis://localhost:6379
# MOCK_API_URL=http://localhost:8080
# SMTP_HOST=localhost SMTP_PORT=1025
```

---

## CI Integration

```yaml
services:
  postgres:
    image: postgres:16-alpine
    env:
      POSTGRES_DB: testdb
      POSTGRES_USER: testuser
      POSTGRES_PASSWORD: testpass
    ports:
      - 5432:5432

steps:
  - run: npm test
    env:
      DATABASE_URL: postgresql://testuser:testpass@localhost:5432/testdb
```

---

## Project Structure

```
docker-test-environments/
├── environments/
│   ├── postgres/
│   │   ├── docker-compose.yml    # PostgreSQL 16 + pgAdmin
│   │   └── init.sql              # Schema + seed data
│   ├── full-stack/
│   │   ├── docker-compose.yml    # PG + Redis + WireMock + Mailhog
│   │   └── wiremock/mappings/    # Mock API responses
│   ├── redis-queue/
│   │   └── docker-compose.yml    # Redis 7 + Commander
│   └── mongo-api/
│       └── docker-compose.yml    # MongoDB 7 + Express
├── scripts/
│   └── start.sh                  # Helper script
└── .github/workflows/validate.yml
```

---

## License

MIT

---

Built by [Quvantic](https://quvantic.com)
