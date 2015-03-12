binary_install() {
    local check=('multitail' 'vim' 'rlwrap' 'ack' 'git' 'nmap')
    local needs_install=()



    # find out where (if anywhere bash completion is)
    BASH_COMPLETION_LOCATION="/etc/bash_completion"
    if regex_match "$OPERATING_SYSTEM" "OSX.*"; then
        if ! is_installed 'brew'; then
            log "Installing Homebrew as it was not found"
            async_command "ruby -e $(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
        fi

        BASH_COMPLETION_LOCATION=`brew --prefix`"$BASH_COMPLETION_LOCATION"
    fi


    for binary in "${check[@]}"; do
        if ! is_installed "$binary"; then
            needs_install+=("$binary")
        fi
    done

    # Make sure vim is installed, and install newer version if needed
    if is_installed 'vim'; then
        log "Asked to check if vim is the correct version"
        if ! regex_match "$(vim --version)" 'VIM - Vi IMproved [7-9]\.[4-9].*'; then
            log "Found that we need to update vim"
            needs_install+=('vim')
        fi
    fi

    log "Found that bash completion could be at $BASH_COMPLETION_LOCATION"

    # Bash Completion is the bomb
    log "Asked if bash-completion is installed"
    if [ ! -f "$BASH_COMPLETION_LOCATION" ]; then
        log "Found that we need to install bash completion"
        needs_install+=('bash-completion')
    fi


    if [ ${#needs_install[@]} -ne 0 ]; then
        log "Found that we need to install ${needs_install[@]}"
        if regex_match "$OPERATING_SYSTEM" '^CentOS.*'; then
            async_command "sudo yum clean all"
            async_command "sudo yum install ${needs_install[@]} -y --enablerepo=*"
        elif regex_match "$OPERATING_SYSTEM" '^OSX.*'; then
            async_command "brew install ${needs_install[@]}"
        fi
    fi
}

binary_install
unset -f binary_install
