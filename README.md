# Recipes

This repository contains all of the recipes required to build AerynOS from source.

[![Repository status](https://repology.org/badge/repository-big/serpentos.svg)](https://repology.org/repository/serpentos)


## Keeping the repository small while we develop our infra and tooling

We are currently working on technology that will allow us to scale the repo out without having to worry as much about ABI mismatched packages.

Until that technology is ready, we are having to be quite strict in terms of which packages we accept for the repository, in order to avoid exploding the amount of manual rebuilds we need to do.

Please understand and accept that this is a conscious choice driven by necessity.


### Current packaging focus

AerynOS should be considered an in-development, Alpha quality, tech preview Linux distribution, which primarily exists to prove out our tooling approach at the moment. This will obviously change as and when the tooling and infrastructure capabilities mature.

The focus for now is squarely on maintaining our currently supported Desktop stacks + development tooling.

The aim right now is to ship the following:

 - The desktop environment (COSMIC, GNOME and KDE are considered stable)
 - Any "lightweight" compositors with associated stack (such Sway and Niri)
 - Flatpak w/ preconfigured flathub
 - GNOME Software / KDE Discover (pending moss integration, which is being worked on)
 - Firefox
 - Thunderbird
 - The development tools for packaging and developing the distribution.

Other areas of focus:

 - Stateless enabling (+ hermetic usr)
 - Kernel enabling
 - Metrics-based performance improvements
 - Package updates and bug fixes


## Packaging onboarding for people using an AerynOS host system

See https://aerynos.dev/packaging/


### Git summary requirements

To keep git summaries readable, AerynOS requires the following git summary format

- `name: Add at v<version>`
- `name: Update to v<version>`
- `name: Fix <...>`
- `[NFC] name: <description of no functional change commit>`


### Using `jq` to parse `manifest.*.jsonc` files

We provide `.jsonc` (JSON with comments) manifest files, however, the popular `jq` tool doesn't currently support `.jsonc` files.

That said, you can use the C preprocessor to strip any comments before passing to `jq` as follows:

`cpp -P -E manifest.x86_64.jsonc | jq .packages`


### Specifying `just` default variables in the `.env` file

Create a `.env` file in the root of the `recipes/` directory, next to the supplied `justfile`.

_Example `.env` file:_

    # All installs need a default local repository set up for convenience
    # If you're awkward and want to use a different path than the default,
    # uncomment and change it below:
    # LOCAL_REPO="${HOME}/.cache/local_repo/x86_64"


### Overriding default boulder arguments

If you are not building on AerynOS using the os-supplied boulder package, or if you want to specify custom arguments
to the boulder invocation when using the `just` targets, you might benefit from adding some or all of the following options
to your `.env` file in recipes/ root next to the `justfile`:

    # Uncomment this if you want to use a different boulder than the one in /usr/bin
    # BOULDER="${HOME}/.local/bin/boulder"
    # Uncomment this if you want to explicitly override the shipped boulder configuration
    # BOULDER_ARGS="--data-dir=${HOME}/.local/share/boulder --config-dir=${HOME}/.config/boulder --moss-root=${HOME}/.cache/boulder"

The `justfile` is set up so you can also choose to specify environment variables on a command-line invocation of `just`:

_Example:_

    BOULDER_ARGS="--data-dir=${HOME}/.local/share/boulder" just build


## License

Unless otherwise specified, all packaging recipes are available under
the terms of the [MPL-2.0](https://spdx.org/licenses/MPL-2.0.html) license.

Individual software releases are available under the terms specified
upstream, collected in each `stone.yaml` recipe. Any patches against
a software package is under the relevant license for each upstream.

Copyright © 2020-2025 Serpent OS Developers.

Copyright © 2025- AerynOS Developers.
