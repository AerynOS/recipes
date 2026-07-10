#!/usr/bin/env sh
# Launches Pear Desktop with flags specified in $XDG_CONFIG_HOME/pear-flags.conf

set -e

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

if [ -r "${XDG_CONFIG_HOME}/pear-flags.conf" ]; then
    PEAR_FLAGS="$(cat "${XDG_CONFIG_HOME}/pear-flags.conf")"
fi

if [ -z "${PEAR_NO_WAYLAND+set}" ]; then
    if [ -z "${ELECTRON_OZONE_PLATFORM_HINT+set}" ]; then
        export ELECTRON_OZONE_PLATFORM_HINT="auto"
    fi
fi

export ELECTRON_IS_DEV=0

# shellcheck disable=SC2086
exec /usr/lib/pear-desktop/youtube-music $PEAR_FLAGS "$@"
