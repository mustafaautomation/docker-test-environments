#!/bin/bash
# Start a test environment
# Usage: ./scripts/start.sh [env-name]
# Available: postgres, full-stack, redis-queue, mongo-api, elasticsearch, rabbitmq

ENV=${1:-postgres}
DIR="environments/$ENV"

if [ ! -d "$DIR" ]; then
  echo "Unknown environment: $ENV"
  echo ""
  echo "Available environments:"
  for d in environments/*/; do
    name=$(basename "$d")
    services=$(grep -c "image:" "$d/docker-compose.yml" 2>/dev/null || echo 0)
    echo "  - $name ($services services)"
  done
  exit 1
fi

echo "Starting $ENV test environment..."
docker compose -f "$DIR/docker-compose.yml" up -d
echo ""
echo "Environment '$ENV' is ready."
echo "Stop with: docker compose -f $DIR/docker-compose.yml down"
