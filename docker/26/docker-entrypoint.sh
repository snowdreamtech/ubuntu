#!/bin/sh
set -e

# Enable debug mode if DEBUG=true
if [ "${DEBUG}" = "true" ]; then
    set -x
fi

# Execute all scripts in entrypoint.d/
if [ -d /usr/local/bin/entrypoint.d ]; then
    for script in /usr/local/bin/entrypoint.d/*; do
        if [ -x "$script" ]; then
            if [ "${DEBUG}" = "true" ]; then
                echo "Executing: $script"
            fi
            "$script" "$@"
        fi
    done
fi

# Execute the main command
exec "$@"
