#!/usr/bin/env zsh

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Primitive CPE search tool
function cpesearch() {
    if [[ -z $1 || $1 == "--help" || $1 == "-h" ]]; then
        echo "usage: cpesearch <package-name>"
    else
        curl -s -X POST https://cpe-guesser.cve-search.org/search -d "{\"query\": [\"$1\"]}" | jq .

        echo "Verify successful hits by visiting https://cve.circl.lu/search/\$VENDOR/\$PRODUCT"
        echo "- CPE entries for software applications have the form 'cpe:2.3:a:\$VENDOR:\$PRODUCT'"
    fi
}


# Goes to the root directory of the AerynOS recipes
# git repository from anywhere on the filesystem.
# This function will only work if this script is sourced
# by your zsh shell.
function gotoaosrepo() {
    SCRIPT_PATH=$functions_source[gotoaosrepo]
    cd $(dirname $(readlink "${SCRIPT_PATH}"))/../
}

# Deprecated, use gotoaosrepo
function gotoserpentrepo() {
    SCRIPT_PATH=$functions_source[gotoserpentrepo]
    cd $(dirname $(readlink "${SCRIPT_PATH}"))/../
}

# Goes to the root directory of the git repository
function goroot() {
    cd $(git rev-parse --show-toplevel)
}

# Change into a package directory
function chpkg() {
    cd $(git rev-parse --show-toplevel)/*/$1
}


# Package name completion
_chpkg()
{
    _list=$(ls $(git rev-parse --show-toplevel)/*/)

    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]] ; then
        COMPREPLY=( $(compgen -W "${_list}" -- ${cur}) )
        return 0
    fi
}

complete -F _chpkg chpkg
