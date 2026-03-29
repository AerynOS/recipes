#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2025 AerynOS Developers
# SPDX-License-Identifier: MPL-2.0
# 
# Remove outdated repos from installed systems
# Intended to be used as a trigger or systemd one-shot service script
# Depends on the 'moss' and 'yq' packages
#

_ARG="$1"
_SEEN_UNSTABLE_URI=0

add-unstable-repo () {
    [[ "${_SEEN_UNSTABLE_URI}" == "1" ]] && return 0
    echo "Adding current unstable-stream package repository (enabling by default) ..."
    moss repo add unstable-stream https://cdn.aerynos.dev/unstable/x86_64/stone.index -p 0 -c "unstable-stream package repository"
    moss repo enable unstable-stream
}


add-disabled-volatile-repo () {
    echo "Adding current volatile-stream package repository (disabling by default) ..."
    moss repo add volatile-stream https://build.aerynos.dev/volatile/x86_64/stone.index -p 10 -c "volatile-stream package repository (for packagers and testing only)"
    moss repo disable volatile-stream
}


remove-repo () {
    [[ -z "$1" ]] && return 0
    local repo="$1"

    echo "Removing outdated ${repo} repository ..."
    moss repo remove "${repo}"
}


handle-repo () {
    [[ -z "$1" ]] && return 0
    local repo="$1"

    local repo_name="$(yq '. | keys[0]' < "${repo}")"
    local repo_uri="$(yq '.*.uri' < "${repo}")"
    local repo_description="$(yq '.*.description' < "${repo}")"
    local repo_priority="$(yq '.*.priority' < "${repo}")"
    echo -e "Found ${repo}:\n - ${repo_name} = ${repo_uri} [${repo_priority}]"

    # We want to get rid of outdated repos
    if [[ ${repo_uri} =~ dev.serpentos.com  ]] || \
       [[ ${repo_uri} =~ packages.aerynos.com ]] || \
       [[ "${repo_uri}" == "https://aerynos.dev/volatile/x86_64/stone.index" ]]
    then
        remove-repo "${repo_name}"
        # If the repo was outdated, we need to add the corresponding current repo
        if [[ "${repo_name}" == "unstable" ]]
        then
            # This can be added multiple times with no issue
            # -- it will simply override the existing repo definition
            add-unstable-repo
            _SEEN_UNSTABLE_URI=1
        elif [[ "${repo_name}" == "volatile" ]]
        then
            # Tame as above, but note that this repo will be disabled by default
            # because we don't want users to inadvertently end up on the package
            # stream where the infra lands packages for testing etc.
            add-disabled-volatile-repo
        fi
    elif [[ "${repo_uri}" == "https://cdn.aerynos.dev/unstable/x86_64/stone.index" ]]
    then
        if [[ "${repo_name}" == "unstable" && "${repo_description}" = "..." ]]
        then
            echo "Updating description for already enabled current unstable repository ..."
            add-unstable-repo
        else
            echo "The new repository URI is already used in the '${repo_name}' repository."
        fi
        _SEEN_UNSTABLE_URI=1
    fi
}


run () {
    for repo in /etc/moss/repo.d/*.yaml
    do
        [[ -f "${repo}" ]] && handle-repo "${repo}" || : # don't die on errors
    done

    # We need to ensure that a default unstable repo is configured
    if [[ "${_SEEN_UNSTABLE_URI}" == "0" ]]
    then
        add-unstable-repo
    fi
}


test () {
    echo -e "\nTest 1:\n"
    moss repo add volatile https://dev.serpentos.com/volatile/x86_64/stone.index -p0
    moss repo add unstable https://dev.serpentos.com/volatile/x86_64/stone.index -p10
    moss repo list

    main
    moss repo list
    echo -e "\nTest 1 done.\n"

    echo -e "\nTest 2:\n"
    moss repo add volatile2 https://dev.serpentos.com/volatile/x86_64/stone.index -p0
    moss repo add unstable2 https://packages.aerynos.com/volatile/x86_64/stone.index -p10
    moss repo list

    main
    moss repo list
    echo -e "\nTest 2 done.\n"

    echo -e "\nTest 3:\n"
    moss repo add unreachable https://aerynos.dev/volatile/x86_64/stone.index -p10
    moss repo list

    main
    moss repo list
    echo -e "\nTest 3 done.\n"
}


main() {
    # if these invariants hold, there's a high probability that this
    # system is one controlled by moss
    if [[ -d /.moss/ && -d /etc/moss/repo.d && -x /usr/bin/moss ]]
    then
        if [[ ! -x /usr/bin/yq ]]
        then
            moss install -y yq
        fi

        if [[ -n "${_ARG}" && "${_ARG}" == "test" ]]
        then
            test
        elif [[ -n "${_ARG}" ]]
        then
            echo "valid args are 'test' (to run tests) or no args (execute normally)"
        else
            echo -e "\nCurrently known moss repositories:\n"
            moss repo list
            echo ""

            run

            echo -e "\nUpdated list of known moss repositories:\n"
            moss repo list
            echo ""
        fi
    else
        echo -e "\n... this system does not appear to be controlled by moss?\n"
    fi
}

main

unset _ARG
unset _SEEN_UNSTABLE
