#!/bin/bash

set -e;

INIT_SCRIPTS_DIR=${INIT_SCRIPTS_DIR:-/init.d}

SCRIPTS=$(find "$CONFIG_DIR" -type f \( -name "*.sh" -o -name "*.py" \) | sort)

for script in $SCRIPTS; do
  echo "Running: $script"
  if [[ "$script" == *.sh ]]; then
    bash "$script"
  elif [[ "$script" == *.py ]]; then
    python3 "$script"
  else
    echo "Unsupported file type: $script"
    continue
  fi
  if [ $? -ne 0 ]; then
    echo "Error while running $script. Stopping."
    exit 1
  fi
done