<!--
# SPDX-FileCopyrightText: 2026 AerynOS Developers
# SPDX-License-Identifier: MPL-2.0
-->

# Thunderbird PR flow

## Thunderbird

    gotoaosrepo
    chpkg thunderbird
    boulder recipe update (...)
    just build
    <git add and commit with suitable message>

## Thunderbird langpacks

    chpkg thunderbird-langpacks
    ./update.py <version of thunderbird above>
    just bump
    just build
    <git add and commit with suitable message>

## Prepare the PR

Push the PR with both packages as separate commits.
