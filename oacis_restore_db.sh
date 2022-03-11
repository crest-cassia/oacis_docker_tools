#!/bin/bash -eu

cd $(dirname $0)
set -x
docker compose exec -u oacis oacis /home/oacis/oacis/bin/oacis_restore_db
