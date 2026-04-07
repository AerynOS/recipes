<!--
# SPDX-FileCopyrightText: 2024 AerynOS Developers
# SPDX-License-Identifier: MPL-2.0
-->

# Suggested test plan for golang

- Install the newly built golang .stone
- Run `go version` and `go env`
- Run `go install github.com/gohugoio/hugo@latest`
- Build a golang-based package w/boulder (ca-certificates is a good choice)

If none of the above give you issues, odds are the build is ready to be PRed.
