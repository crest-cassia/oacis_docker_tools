#!/bin/bash -eu

cd $(dirname $0)
if [ ! -e "Result/db_dump" ]; then
  echo "===== db_dump file 'Result/db_dump' is not found ====="
  exit 1
fi

set -x
docker compose exec -u oacis oacis /home/oacis/oacis/bin/oacis_restore_db
