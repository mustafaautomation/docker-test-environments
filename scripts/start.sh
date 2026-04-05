#!/bin/bash
# Start a test environment
# Usage: ./scripts/start.sh [postgres|full-stack|redis-queue|mongo-api]

ENV=${1:-postgres}
DIR="environments/$ENV"

if [ ! -d "$DIR" ]; then
  echo "Unknown environment: $ENV"
  echo "Available: postgres, full-stack, redis-queue, mongo-api"
  exit 1
fi

echo "Starting $ENV test environment..."
docker compose -f "$DIR/docker-compose.yml" up -d
echo ""
echo "Environment '$ENV' is ready."
echo "Stop with: docker compose -f $DIR/docker-compose.yml down"
