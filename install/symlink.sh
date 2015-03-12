symlink_files() {
    log "Started the symlink step"

    for source in `find_this '*.syml'`; do
        log "Found file $source"
        local dest="$HOME/.`basename \"${source%.*}\"`"
        log "that should go to $dest"

        link_files $source $dest
    done
}

symlink_files
unset -f symlink_files
