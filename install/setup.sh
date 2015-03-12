#! /bin/sh
#
# setup.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

if [ ! -f "$DOT_CONFIG_FILE" ]; then
    touch $DOT_CONFIG_FILE
fi
source $DOT_CONFIG_FILE


# remove all files in temp
rm -rf "$DOT_TMP_ROOT"/*

# Truncate/create log file
: > $DOT_LOG_FILE
log_header "Setup"

# Setup
# Open a new file descriptor that redirects to stdout
# Allowing us to print to stdout in a function
exec 3>&1

# Remove All aliases
unalias -a


start_time=$(date +%s%N)
log "Started at $(date)"
log "Dotfiles root is $DOTFILES_ROOT"

FIND_EXCLUDE=()

 # Find out what OS we are one

OPERATING_SYSTEM="UNKNOWN"
if is_installed "sw_vers" >/dev/null; then
    OPERATING_SYSTEM="OSX $(sw_vers -productVersion)"
elif is_installed 'lsb_release' 2>&1 >/dev/null; then
    OPERATING_SYSTEM="$(lsb_release -a 2> /dev/null | grep 'Description' | sed -e 's/Description:\t//')"
elif [ -f "/etc/*release*" ]; then
    OPERATING_SYSTEM=$(cat /etc/*release*)
elif [ -f "/etc/issue" ]; then
    OPERATING_SYSTEM=$(cat /etc/issue)
fi


if ! regex_match "$OPERATING_SYSTEM" "OSX.*"; then
    FIND_EXCLUDE+=("'*/osx/*'")
fi

# Setup Path
pathadd "/usr/local/bin"
pathadd "/usr/bin"
pathadd "/bin"
pathadd "/usr/sbin"
pathadd "/sbin"
pathadd "$DOT_CUST_ROOT/bin"
pathadd "$DOT_DIST_ROOT/bin"
pathadd "$HOME/bin"
pathadd "./node_modules/.bin"
pathadd "./vendor/bin"
pathadd "./bin"
