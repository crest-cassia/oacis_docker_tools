#!/bin/bash -eu

cd $(dirname $0)
set -x
docker compose stop -t 60

