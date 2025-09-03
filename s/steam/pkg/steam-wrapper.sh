#!/usr/bin/env bash

# Default to using bundled libraries if missing from system
: ${STEAM_RUNTIME:=1}
export STEAM_RUNTIME

# Since we're a default-libc++ distro we need to preload libstdc++ to avoid crashes.
# Only preload the 32bit version or the client won't work at all (update 2025-09-01,
# client seems to work with 64bit preloaded, which is required for Counter-Strike 2)
export LD_PRELOAD+="${LD_PRELOAD+:}/usr/lib/libstdc++.so.6:/usr/lib32/libstdc++.so.6"

# Steam renames LD_LIBRARY_PATH to SYSTEM_LD_LIBRARY_PATH and it then becomes
# ineffective against games. We unfortunately therefore have to force the value
# through via STEAM_RUNTIME_LIBRARY_PATH instead.
export STEAM_RUNTIME_LIBRARY_PATH="${LD_LIBRARY_PATH}"

. "${0%/*}"/../lib/steam/bin_steam.sh
