#!/usr/bin/env sh
# Launch tidal-hifi with optional user flags.

set -e

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
TIDAL_HIFI_FLAGS="--no-sandbox"

if [ -r "${XDG_CONFIG_HOME}/tidal-hifi-flags.conf" ]; then
    TIDAL_HIFI_FLAGS="$(cat "${XDG_CONFIG_HOME}/tidal-hifi-flags.conf")"
fi

if [ -z "${ELECTRON_OZONE_PLATFORM_HINT+set}" ]; then
    export ELECTRON_OZONE_PLATFORM_HINT="auto"
fi

# shellcheck disable=SC2086
exec /usr/lib/tidal-hifi/tidal-hifi $TIDAL_HIFI_FLAGS "$@"
