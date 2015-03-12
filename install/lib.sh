#! /bin/sh
#
# lib.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

is_installed() {
    if [ "$#" -ne "1" ]; then
        echo 'Usage:'
        echo "  check_install <name>"
        echo
        echo "Example:"
        echo "  check_install ack"
        echo
        return 1
    fi

    if command -v $1 >/dev/null; then
        return 0
    fi
    return 1
}

regex_match() {
    if [ "$#" -ne "2" ]; then
        echo 'Usage:'
        echo "  regex_match <string> <regex>"
        echo
        echo "Example:"
        echo "  regex_match 'derp' '^derp$'"
        echo
        return 1
    fi

    if [ -n "$(echo "$1" | grep  -E "$2")" ]; then
        return 0
    fi
    return 1
}

pathadd() {
    if [ "$#" -ne "1" ]; then
        echo 'Usage:'
        echo "  pathadd <dir>"
        echo
        echo "Example:"
        echo "  pathadd '/etc/nope'"
        echo
        return 1
    fi

    local binary="$(echo "$1" | sed -e 's~/$~~')"
    if [ -z "$(echo "$PATH" | grep -E "(^|:)$binary(:|$)")" ]; then
        if [ "$PATH" == "" ]; then
            PATH="$binary"
        else
            PATH+=":$binary"
        fi
    fi
}

pathrm() {
    if [ "$#" -ne "1" ]; then
        echo 'Usage:'
        echo "  pathrm <dir>"
        echo
        echo "Example:"
        echo "  pathrm '/etc/nope'"
        echo
        return 1
    fi

    local binary="$(echo "$1" | sed -e 's~/$~~')"
    if [ -n "$(echo "$PATH" | grep -E "(^|:)$binary(:|$)")" ]; then
        PATH="$(echo "$PATH" | sed -e "s~:$binary$~~")"
        PATH="$(echo "$PATH" | sed -e "s~$binary:~~")"
    fi
}

log() {
    if [ -n "${1:-}" ]; then
        for var in "$@"; do
            # newline is seprate so that trailing newlines don't escape it
            printf "$var" >> "$DOT_LOG_FILE"
            printf "\n" >> "$DOT_LOG_FILE"
        done
    else
        while read var; do
            log "$var"
        done
    fi
}

log_header() {
    log "\n* ----------$1---------- *"
}
info() {
    # Open a new file descriptor that redirects to stdout
    # Allowing us to print to stdout in a function
    exec 3>&1

    for var in "$@"; do
        echo "$var" 1>&3
    done

    # Close our file descriptor
    exec 3>&-
}

ask_user () {
    local answer=""
    local question="$1 [y/n]"
    while [ "$answer" != 'y' ] && [ "$answer" != 'n' ] && [ "$answer" != 'Y' ] && [ "$answer" != 'N' ]; do
        log "Going to ask user $question"
        info "$question"
        read -e answer
        log "user answered $answer"
    done
    if [ "$answer" == "y" ]; then
        return 0
    fi
    return 1
}

link_files () {
    if [ ! -L "$2" ]; then
        if [ -f "$2" ] || [ -d "$2" ]; then
            log "$2 already exists, backing it up to $DOT_BACK_ROOT"
            info "Backing up $2 to $DOT_BACK_ROOT"
            mv $2 $DOT_BACK_ROOT
        fi
    else
        log "$2 already exists as a symlink unlinking"
        unlink "$2"
    fi

    ln -s "$1" "$2"
    log "Linking $1 to $2"
}

find_this () {
    local extension=$1; shift
    local dir="$DOTFILES_ROOT"
    local exclude=()

    while test $# -gt 0; do
        exclude+=("$1"); shift
    done
    for global_exclude in "${FIND_EXCLUDE[@]}"; do
        exclude+=("$global_exclude")
    done

    # http://unix.stackexchange.com/questions/29509/transform-an-array-into-arguments-of-a-command
    if [ ${#exclude[@]} -ne 0  ]; then
        find "$dir" -not -type l -name $extension ${exclude[@]/#/-not -path }
    else
        find "$dir" -not -type l -name $extension
    fi
}

change_config() {
    if [ -z "$1" ]; then
        return
    fi
    if [ -z "$2" ]; then
        return
    fi
    if [ ! -f $DOT_CONFIG_FILE ]; then
        touch $DOT_CONFIG_FILE
    fi

    log "Asked to change $1 to $2"
    local result="$(cat $DOT_CONFIG_FILE | grep "$1=")"
    if [ -z "$result" ]; then
        log "$1 is not currently in config writing it in"
        echo "$1=\"$2\"" >> $DOT_CONFIG_FILE
    else
        log "Found that $1 is currently $result"
        log "Old Config was:"
        log " "
        log "$(cat $DOT_CONFIG_FILE)"
        log " "
        local new_config="$(cat $DOT_CONFIG_FILE | sed -e "s~$1=\".*\"~$1=\"$2\"~")"
        log "New Config is: "
        log " "
        log "$new_config"
        log " "
        echo "$new_config" > "$DOT_CONFIG_FILE"
    fi
}

get_config() {
    if [ -z "$1" ]; then
        return
    fi
    if [ ! -f $DOT_CONFIG_FILE ]; then
        touch $DOT_CONFIG_FILE
    fi

    local result="$(cat $DOT_CONFIG_FILE | grep "$1=" | sed -e "s/$1=\"//" | sed -e 's/"$//')"
    log "Asked to get the value of $1 and found $result"
    echo "$result"
}

async_command() {
    log "Running Async command $1"
    (eval "$1" 2>&1 | while read line; do echo "Async '$1' returned : $line"; done | log &)

}

fullpath() {
    if [ "$#" -ne "1" ]; then
        echo 'Usage:'
        echo "  fullpath <dir>"
        echo
        echo "Example:"
        echo "  fullpath './test.sh'"
        echo
        return 1
    fi

    echo "$( cd "$( dirname "$1" )" && pwd )/$(basename "$1")"
}

# Check if a variable isset even through nounset
isset() {
    eval "local thing=\${$1:-}"
    if [ ! -z "${thing:-}" ]; then
        return 0
    fi
    return 1
}

