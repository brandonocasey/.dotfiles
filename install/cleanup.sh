#! /bin/sh

# Setup dot for next time
link_files "$DOT_LOC" "$HOME/.bash_profile"
end_time=$(date +%s)
final_time=$(($end_time - $start_time))
log "All Done at $(date)"
log "Overall dot took $final_time seconds"
unset -f log
unset -f ask_user
unset -f link_files
unset -f info
unset -f find_this
unset -f log_header
unset -f change_config
unset FIND_EXCLUDE
unset BASH_COMPLETION_LOCATION
