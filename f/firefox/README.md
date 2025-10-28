# Firefox PR flow

## Firefox

    gotoaosrepo
    chpkg firefox
    boulder recipe update (...)
    just build
    <git add and commit with suitable message>

With PGO, the build takes around 70-75 minutes on an R9 5950X 16c/32t system w/NVMe 4x4 drive.

## Firefox langpacks

    chpkg firefox-langpacks
    ./update.py <version of firefox above>
    just bump
    just build
    <git add and commit with suitable message>

## Prepare the PR

Push the PR with both packages as separate commits.
