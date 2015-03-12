# Source global definitions
if [ -f /etc/bashrc ]; then
    log "Sourced global definitions"
    source /etc/bashrc
fi

# Source local definitions
if [ -f ~/.localrc ]; then
    log "Sourced local definitions"
    source ~/.localrc
fi

# Source all .bash files into shell
log "Sourcing Dist Files:\n"
for file in `find_this '*.bash'`; do
    log "$file"
    source "$file"
done


if [ -z "$BASH_COMPLETION_LOCATION" ]; then
    if [ -f "/etc/bash_completion" ]; then
        BASH_COMPLETION_LOCATION="/etc/bash_completion"
    elif [ -f "/usr/local/etc/bash_completion" ]; then
        BASH_COMPLETION_LOCATION="/usr/local/etc/bash_completion"
    fi
fi

if [ -f "$BASH_COMPLETION_LOCATION" ]; then
    if [ -n "$DEBUG_DOT" ]; then
        set +u
    fi
    source "$BASH_COMPLETION_LOCATION" &
    disown
    log "Sourced $BASH_COMPLETION_LOCATION"
    if [ -n "$DEBUG_DOT" ]; then
        set -u
    fi
fi
