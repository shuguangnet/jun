#!/bin/sh
# Run a dev build of Jun with its own config and settings, kept in priv/
# (gitignored), so it does not share files with an installed Jun.
set -e
cd "$(dirname "$0")"
mkdir -p priv
JUN_CONFIG_PATH="$PWD/priv/config.dev.json" JUN_SETTINGS_PATH="$PWD/priv/settings.dev.yaml" exec go run ./cmd/jun
