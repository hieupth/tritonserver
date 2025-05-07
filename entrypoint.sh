#!/bin/bash

CONFIG_DIR="/entry.d"

SCRIPTS=$(find "$CONFIG_DIR" -type f -name "*.sh" | sort)

for script in $SCRIPTS; do
    echo "Running: $script"
    
    bash "$script"
    
    if [ $? -ne 0 ]; then
        echo "Error while running $script. Stopping."
        exit 1
    fi
done

echo "All scripts executed successfully."