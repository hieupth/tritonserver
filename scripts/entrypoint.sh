#!/bin/sh

set -e;

if [ "${ENABLE_HOOK}" = "true" ]; then
  bash /scripts/hook.sh
fi;

tritonserver --model-repository=${MODELS_DIR:-/models}