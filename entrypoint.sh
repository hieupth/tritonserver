#!/bin/sh

set -e;

if [ "${RUN_INIT_SCRIPTS}" = "true" ]; then
  bash /init.d/init.sh
fi

exec "$@"