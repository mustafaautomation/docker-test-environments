#!/bin/bash
# Validates Docker Compose files for structural correctness
# Works without Docker installed — checks YAML structure with Python
set -e

ERRORS=0
TOTAL=0

echo "Validating Docker test environments..."
echo ""

for dir in environments/*/; do
  TOTAL=$((TOTAL + 1))
  env_name=$(basename "$dir")
  compose_file="$dir/docker-compose.yml"

  if [ ! -f "$compose_file" ]; then
    echo "❌ $env_name: missing docker-compose.yml"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Validate YAML syntax and check required fields
  result=$(python3 -c "
import yaml, sys

with open('$compose_file') as f:
    data = yaml.safe_load(f)

if not isinstance(data, dict):
    print('ERROR: Not a valid compose file')
    sys.exit(1)

services = data.get('services', {})
if not services:
    print('ERROR: No services defined')
    sys.exit(1)

issues = []
for name, svc in services.items():
    if not isinstance(svc, dict):
        issues.append(f'{name}: not a mapping')
        continue
    if 'image' not in svc and 'build' not in svc:
        issues.append(f'{name}: no image or build')
    if 'ports' not in svc:
        issues.append(f'{name}: no ports exposed')

for issue in issues:
    print(f'WARNING: {issue}')

print(f'OK: {len(services)} services')
" 2>&1)

  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo "❌ $env_name: $result"
    ERRORS=$((ERRORS + 1))
  else
    service_count=$(echo "$result" | grep "^OK:" | sed 's/OK: //')
    warnings=$(echo "$result" | grep "^WARNING:" | wc -l | tr -d ' ')
    if [ "$warnings" -gt 0 ]; then
      echo "⚠️  $env_name: $service_count (${warnings} warnings)"
    else
      echo "✅ $env_name: $service_count"
    fi
  fi
done

echo ""
echo "Validated $TOTAL environments, $ERRORS errors"

if [ $ERRORS -gt 0 ]; then
  exit 1
fi

echo "All environments valid!"
