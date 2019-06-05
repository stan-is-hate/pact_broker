#!/bin/bash

: "${1:?Please specify file to restore}"

docker exec -it pact-broker-postgres pg_restore -h localhost -U postgres -d postgres /data/$1
