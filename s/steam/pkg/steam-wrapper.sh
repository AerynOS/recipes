#!/usr/bin/env bash

# Default to using bundled libraries if missing from system
: ${STEAM_RUNTIME:=1}
export STEAM_RUNTIME

# Steam renames LD_LIBRARY_PATH to SYSTEM_LD_LIBRARY_PATH and it then becomes
# ineffective against games. We unfortunately therefore have to force the value
# through via STEAM_RUNTIME_LIBRARY_PATH instead.
export STEAM_RUNTIME_LIBRARY_PATH="${LD_LIBRARY_PATH}"

. "${0%/*}"/../lib/steam/bin_steam.sh
