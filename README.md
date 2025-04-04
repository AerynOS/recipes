## Recipes

This repository contains all of the recipes required to build AerynOS
from source.

[![Repository status](https://repology.org/badge/repository-big/serpentos.svg)](https://repology.org/repository/serpentos)

## Onboarding for people using a AerynOS host system

See https://aerynos.dev/packaging/

## Onboarding for people not using an AerynOS host system

### Quick start for boulder

`boulder` and `moss` rely on so-called `subuid` and `subgid` support.
If you do not already have this set up for your user in `/etc/subuid` and `/etc/subuid`, run this:

```bash
$ sudo touch /etc/sub{uid,gid}
$ sudo usermod --add-subuids 1000000-1065535 --add-subgids 1000000-1065535 root
$ sudo usermod --add-subuids 1065536-1131071 --add-subgids 1065536-1131071 "$USER"
```

If you are not building on AerynOS, you're going to have to install `boulder` first.
See [its readme][moss-boulder-readme] for instructions.

[moss-boulder-readme]:(https://github.com/AerynOS/os-tools#-onboarding)

### Setting up Lints and Hooks

Ensuring that the `just` cli application is installed, run `just init`.

This will setup git hooks that will lint for the most common packaging errors upon `git commit`, as well as
fill out commit message templates for you.

### Add a local repository

Our `justfile` defaults to using the `local-x86_64` build profile with boulder.

While we traditionally shipped this pre-enabled configuration, we figured that mandating `root`-user and world-accessible directories was generally a Bad Move.


**Create an empty local repository**

The path you use for this doesn't matter much, as long as the user account you want to use
to run `boulder` has read/write access to it.

```bash
# Set up an XDG compliant local_repo w/explicit architecture
$ mkdir -pv ~/.cache/local_repo/x86_64/
$ moss index ~/.cache/local_repo/x86_64/
```


**Add the local repository to the repositories known to `moss`**

If you're on AerynOS, you will want to make the local repository available for package
installation.

To do so, run the following command:

```bash
$ sudo moss repo add local file://${HOME}/.cache/local_repo/x86_64/stone.index -p 100
```


**Create a boulder build profile**

We'll add the (unversioned) volatile repository¹ at the bottom layer, and elevate our
local repository priority to take precedence.

```bash
$ boulder profile add \
    --repo name=volatile,uri=https://packages.serpentos.com/volatile/x86_64/stone.index,priority=0 \
    --repo name=local,uri=file://${HOME}/.cache/local_repo/x86_64/stone.index,priority=100 \
    local-x86_64
```

¹ this repository should not be used for anything but packaging!


**Specifying `just` default variables in the `.env` file**

Create a `.env` file in the root of the `recipes/` directory, next to the supplied `justfile`.

_Example `.env` file:_

    # All installs need a default local repository set up for convenience
    # If you're awkward and want to use a different path than the default,
    # uncomment and change it below:
    # LOCAL_REPO="${HOME}/.cache/local_repo/x86_64"

The `justfile` is set up so you can also choose to specify either of the above environment variables on a command-line invocation of `just`:

_Example:_

    BOULDER_ARGS="--data-dir=${HOME}/.local/share/boulder" just build


**Overriding default boulder arguments**

If you are not building on AerynOS using the os-supplied boulder package, or if you want to specify custom arguments
to the boulder invocation when using the `just` targets, you might benefit from adding some or all of the following options
to your `.env` file in recipes/ root next to the `justfile`:

    # Uncomment this if you want to use a different boulder than the one in /usr/bin
    # BOULDER="${HOME}/.local/bin/boulder"
    # Uncomment this if you want to explicitly override the shipped boulder configuration
    # BOULDER_ARGS="--data-dir=${HOME}/.local/share/boulder --config-dir=${HOME}/.config/boulder --moss-root=${HOME}/.cache/boulder"

## Do a test build

Try invoking `pushd m/m4/ && just build` or `pushd n/nano && just build` for a quick and easy confirmation that everything works OK.


## Git summary requirements

To keep git summaries readable, AerynOS requires the following git summary format

- `name: Add at v<version>`
- `name: Update to v<version>`
- `name: Fix <...>`
- `[NFC] name: <description of no functional change commit>`

The use of the `Initial inclusion` verbiage is _strongly discouraged_.


## Using `jq`

We provide `.jsonc` (JSON with comments) manifest files, however, the popular `jq` tool doesn't currently support `.jsonc` files.

That said, you can use the C preprocessor to strip any comments before passing to `jq` as follows:

`cpp -P -E manifest.x86_64.jsonc | jq .packages`


## Current focus

Packaging focus should be on bringing up the GNOME Desktop + associated stack

Other areas of focus:

 - Stateless enabling (+ hermetic usr)
 - Kernel enabling
 - Metrics-based performance improvements
 - Package updates and bug fixes

The aim for our desktop right now is to ship the following:

 - GNOME Shell
 - Flatpak w/ preconfigured flathub
 - GNOME Software (pending moss integration)
 - Ptyxis
 - Nautilus
 - GNOME Control Center
 - Firefox
 - Thunderbird


## License

Unless otherwise specified, all packaging recipes are available under
the terms of the [MPL-2.0](https://spdx.org/licenses/MPL-2.0.html) license.

Individual software releases are available under the terms specified
upstream, collected in each `stone.yaml` recipe. Any patches against
a software package is under the relevant license for each upstream.

Copyright © 2020-2025 Serpent OS Developers.
Copyright © 2025 AerynOS Developers.
