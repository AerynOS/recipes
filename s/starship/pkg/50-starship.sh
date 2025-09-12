##
## Initialises starship prompt for interactive shells
## Removing starship package will also remove this initialisation
##

# Check for interactive shell the POSIX sh way
[ -t 0 ] || return 0

# The linux console terminal emulator can't show the default starship prompt...
case "$TERM" in
    "linux") return 0;;
esac

# Initialise starship prompt with serpent's default prompt
[ ! -d ~/.config ] && mkdir ~/.config
[ ! -e ~/.config/starship.toml ] && starship preset aeryn-os -o  ~/.config/starship.toml

# For bash
[ -n "$BASH_VERSION" ]  && eval "$(starship init bash)"

# For zsh
[ -n "$ZSH_VERSION" ] && eval "$(starship init zsh)"
