install_repos() {
    local search=""
    if regex_match "$OPERATING_SYSTEM" '^CentOS.*'; then
        log "installing repositories"
        search="UNKNOWN"
        # centos 5
        if regex_match "$OPERATING_SYSTEM" '^CentOS.*6.*$'; then
            search="repo6"
        elif regex_match "$OPERATING_SYSTEM" '^CentOS.*5.*$'; then
            search="repo5"
        fi

        log "looking for $search extension"
        # find the repo and $search repo files and stuff them into /etc/yum.repos.d
        if [ "$search" != 'UNKNOWN' ];then
            log "installing centos repos with $search"
            for file in `find_this "*.$search"`; do
                log "Found file $file"
                # get rid of the .repo5/6 extension and make it .repo only
                local real_name=$(basename "${file%.*}")
                real_name="$real_name".repo
                log "Found that actual name should be $real_name"

                # false
                local doesnt_exist=1
                for repo_name in `cat $file | grep -oE '\[(.*)\]' | sed -e 's~\[~~' | sed -e 's~\]~~'`; do
                    # make sure that it is not already installed
                    log "checking if [$repo_name] is in the repo list"
                    for repo_file in `find_this "*.repo" "/etc/yum.repos.d"`; do
                        if [ -n "$(grep -E '^\['$repo_name'\]$' $repo_file )" ];  then
                            log "$repo_name is in the repolist"
                            doesnt_exist=0
                        fi

                    done
                done
                if [ "$doesnt_exist" -eq "0" ]; then
                    sudo cp "$file" "/etc/yum.repos.d/$real_name"
                fi
            done
        fi
    fi
}
install_repos
unset -f install_repos
