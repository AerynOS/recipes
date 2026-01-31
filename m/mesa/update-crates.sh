#!/usr/bin/env bash
set -euo pipefail

TARGET="stone.yaml"
URL="https://gitlab.freedesktop.org/mesa/mesa/-/archive/main/mesa-main.tar.gz?path=subprojects"

grep -q "##@@BEGIN_UPSTREAMS" "$TARGET" || { echo "Markers missing"; exit 1; }

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
{
    echo "##@@BEGIN_UPSTREAMS"
    wget -qO- "$URL" | tar -xzO --wildcards "*-rs.wrap" | \
    awk -F ' *= *' '
        /source_url/        {u=$2}
        /source_hash/       {h=$2}
        /source_filename/   {f=$2}

        u && h && f {
            printf "    - %s:\n", u
            printf "        hash: %s\n", h
            printf "        rename: %s\n", f
            print  "        unpack: false"
            u=h=f=""
        }'
    echo "##@@END_UPSTREAMS"
} > "$TMP"

sed -i -e "/##@@BEGIN_UPSTREAMS/,/##@@END_UPSTREAMS/ { /##@@END_UPSTREAMS/ r $TMP" -e "d }" "$TARGET"
