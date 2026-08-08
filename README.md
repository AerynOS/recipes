<!--
# SPDX-FileCopyrightText: 2020 AerynOS Developers
# SPDX-License-Identifier: MPL-2.0
-->

# Recipes

This repository contains all the recipes required to build AerynOS from source.

## Quick Links

| Resource | Description |
|----------|-------------|
| [Documentation](https://aerynos.dev/) | Learn about AerynOS concepts and packaging |
| [Packaging Policy](https://github.com/aerynOS/recipes/blob/main/PACKAGING_POLICY.md) | aerynOS Package Addition Policy |
| [Packaging Guide](https://aerynos.dev/packaging/) | Detailed packaging documentation |
| [Zulip Chat](https://aeryn.zulipchat.com/) | Community discussion (requires join) |
| [Contributing Guidelines](https://github.com/aerynOS/.github/blob/main/CONTRIBUTING.md) | Full contribution process and policies |
| [GenAI Policy](https://github.com/aerynOS/.github/blob/main/CONTRIBUTING.md#llm-contributions) | We do not accept contributions authored using genAI/LLM chatbots or agents |

## What Are Recipes?

Recipes define how packages are built and packaged for AerynOS. Each recipe describes the build process, dependencies, and metadata needed to create installable packages using our tooling stack (primarily Boulder/moss).

## Contributing to Recipes

### Step 1: Understand the Scope

AerynOS is currently in Alpha quality and serves as a tech preview focused on proving our tooling approach. Until our infrastructure matures, we must be selective about packages to avoid exploding manual rebuild requirements.

**Where we are currently at:**

 - We already have 7 DE / WM environments in our repository
 - We ship Flatpak w/ preconfigured flatpub
 - We include the apps our staff need to dogfood aerynOS day to day
 - The development tools for packaging and developing the distribution.
 
**What packages are we likely to accept:**
 - Do not require complex rebuild dependency chains
 - You are willing to maintain over the long term
 - Have appropriate Open Source Licences with permission to redistribute

**Other areas of focus:**
 - Stateless enabling (+ hermetic usr)
 - Kernel enabling
 - Metrics-based performance improvements of packages
 - Package updates and bug fixes

Until our infrastructure matures, if packages are not available in our repository, you may be asked to use Flatpaks and AppImages instead.

### Step 2: Review Requirements

Before submitting, ensure you understand:

- **Git Commit Messages**: Follow our summary format (`name: Add at v<version>`, `name: Update to v<version>`, `name: Fix <...>`, `[NFC] name: <description of no functional change commit>`)
- **Repository Size**: We're actively working on technology to scale the repo without ABI mismatch concerns. Until then, strict package acceptance applies.
- **GenAI Policy**: We do not accept contributions authored using generative AI/LLM chatbots or agents. Our goal is human skill development, not atrophy through automation. [Read more in our contributing guidelines](https://github.com/aerynOS/.github/blob/main/CONTRIBUTING.md#llm-contributions).

### Step 3: Submit a Pull Request

#### Creating Your First PR

GitHub doesn't natively support selecting from multiple PR templates, so we've set up a semi-manual workflow:

1. **Click "New Pull Request"** to begin the PR creation process

2. **Use the Preview Box**: In the PR description area, click the **Preview** tab to access our template selector

3. **Choose the Right Template**:
   - Select the template that best matches your contribution type
   - Common templates include: New Recipe, Recipe Update, Bug Fix, Documentation

4. **Fill Out the Template Completely**: Provide all requesting information, which will vary depending on the template

5. **Submit Your PR**: Once complete, submit and wait for maintainer review.

#### Tips for Faster Review

- Test builds on an AerynOS host system before submitting
- Follow existing recipe patterns and coding style
- Include clear commit messages following our git summary format
- Link related GitHub issues if applicable
- Be responsive to reviewer feedback

Reviews may take some time depending on maintainer availability. Once your PR passes review, a maintainer will merge it. 🎉

## Packaging on AerynOS

### Just Commands

Common `just` commands for local testing:

- `just bump` - bump the release number in the nano recipe
- `just build` - Build the recipe locally
- `just mv-local` - Move the newly built `.stone` build artifacts to the local repository
- `just ls-local` - List the build artifacts present in the local repository
- `just clean` - Clean `*.stone` artefacts from the current directory
- `just clean-local` - Clean `*.stone` artefacts from the local repository

Refer to the `justfile` in the repository root for the full command list.

### Using `jq` to Parse `manifest.*.jsonc` Files

We provide `.jsonc` (JSON with comments) manifest files, however, the popular `jq` tool doesn't currently support `.jsonc` files.

That said, you can use the C preprocessor to strip any comments before passing to `jq` as follows:

`cpp -P -E manifest.x86_64.jsonc | jq .packages`

### Specifying `just` Default Variables in the `.env` File

Create a `.env` file in the root of the `recipes/` directory, next to the supplied `justfile`.

_Example `.env` file:_

    # All installs need a default local repository set up for convenience
    # If you're awkward and want to use a different path than the default,
    # uncomment and change it below:
    # LOCAL_REPO="${HOME}/.cache/local_repo/x86_64"

### Overriding Default `boulder` Arguments

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

## Getting Help

### Where to Get Help and Ask Questions

1. **[Documentation](https://aerynos.dev/)** - Start here for concepts and guides
2. **[Zulip](https://aeryn.zulipchat.com/)** - Our community chat server:
   - **General** - Open to everyone, good starting point
   - **Onboarding (packaging etc.)** - A good place for interacting on packaging
   - **Questions** - For general questions you may have
3. **GitHub Issues** - For bugs and feature requests; search first to avoid duplicates

### Role-Based Access

Note that while Zulip channels are publicly viewable, participation in certain channels requires the `Trusted Contributor` role. This is granted after demonstrating genuine interest in contributing to the project.

## License

Unless otherwise specified, all packaging recipes are available under the terms of the [**MPL-2.0**](https://spdx.org/licenses/MPL-2.0.html) licence.

Individual software releases are available under the terms specified upstream, collected in each `stone.yaml` recipe. Any patches against a software package is under the relevant license for each upstream.
