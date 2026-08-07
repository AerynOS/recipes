#!/bin/sh
set -e

STATE_DIR="/var/lib/moss/triggers/presets"

SYSTEMCTL="/usr/bin/systemctl"

TARGET="$1"

UNIT="$2"

if [ ! -d "${STATE_DIR}" ]; then
    exit 0
fi

if [ "${TARGET}" = "system" ]; then
    STATE_FILE="${STATE_DIR}/system-${UNIT}"

    if [ ! -f "${STATE_FILE}" ]; then
        ${SYSTEMCTL} preset "${UNIT}" --root=/ --force

        touch "${STATE_FILE}"
    fi
elif [ "${TARGET}" = "user" ]; then
    STATE_FILE="${STATE_DIR}/user-${UNIT}"

    if [ ! -f "${STATE_FILE}" ]; then
        ${SYSTEMCTL} preset "${UNIT}" --root=/ --force --global

        touch "${STATE_FILE}"
    fi
fi
