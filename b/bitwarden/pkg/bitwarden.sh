#!/usr/bin/sh

# disable core dumps
ulimit -c 0

# memory protection: prevent debugger attachment and memory reads
export LD_PRELOAD=/usr/lib/bitwarden/libprocess_isolation.so

exec /usr/lib/bitwarden/bitwarden $@
