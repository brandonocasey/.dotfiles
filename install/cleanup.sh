#! /bin/sh

# Setup dot for next time
link_files "$DOT_LOC" "$HOME/.bash_profile"
log "All Done at $(date)"
unset -f log
unset -f ask_user
unset -f link_files
unset -f info
unset -f find_this
unset -f log_header
unset -f change_config
unset FIND_EXCLUDE
unset BASH_COMPLETION_LOCATION
