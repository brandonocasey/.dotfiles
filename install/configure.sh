configure_dotfiles() {
    GIT_ROOT="$DOT_DIST_ROOT/git/"
    SSH_ROOT="$DOT_DIST_ROOT/ssh/"

    if [ -z "$(get_config 'do_install')" ]; then
        if ask_user "Do you want to install additional binaries on this box?"; then
            change_config "do_install" "0"
        else
            change_config "do_install" "1"
        fi
    fi

    if [ ! -f $GIT_ROOT/gituser.syml ]; then

        if ask_user "Do you care to setup git?"; then
            log 'Setting up git config'

            git_credential='cache'
            if regex_match "$OPERATING_SYSTEM" "OSX.*"; then
                git_credential='osxkeychain'
            fi

            log "Git credential helper is $git_credential"

            info 'What is your github author name?'
            read -e git_authorname
            info 'What is your github author email?'
            read -e git_authoremail

            log "User says his author name is $git_authorname and his email is $git_authoremail"

            sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" $GIT_ROOT/gituser.example > $GIT_ROOT/gituser.syml

            log "GIT setup was successfull"
        else
            log "User does not care to install git"
            touch $GIT_ROOT/gituser.syml
        fi
    else
        log "Found That git has already been configured"
    fi

    if [ ! -f $SSH_ROOT/user.sshc ]; then
        log "SSH Setup"

        file="Host *\n"
        if ask_user 'Do you ssh as a different user all the time?'; then
            info 'What is the other ssh user name?'
            read -e ssh_username

            log "User wants his ssh username to be $ssh_username"
            file+="    User $ssh_username\n"
            log "SSH Setup Complete"
        fi


        if ask_user 'Do you want to forward your ssh agent?'; then
            log "user wants to forward his ssh agent"
            file+="    ForwardAgent yes\n"
        fi
        echo -e "$file\n" > $SSH_ROOT/user.sshc
        log "SSH Setup Complete"

    fi
    new_config=""
    ssh_location="$HOME/.ssh"

    change_config "do_ssh_config" "0"
    if [ ! -L $ssh_location/config ] && [ -f $ssh_location/config ]; then
        log "User has their own ssh config"
        if ! ask_user "You already have an ssh config, do you want to overwrite it?"; then
            log "User does not want to compile an ssh config"
            change_config "do_ssh_config" "1"
        fi
    fi

    if [ -L $ssh_location/config ] || [ "$(get_config 'do_ssh_config')" == "0" ] || [ ! -f $ssh_location/config ]; then
        log "Compiling an ssh config"
        if [ ! -f $ssh_location ]; then
            link_files "$DOT_TMP_ROOT/ssh_config" "$ssh_location/config"
        fi
        for FILE in `find_this '*.sshc'`; do
            log "Found a file $FILE"
            new_config="$new_config\n\n"`cat $FILE`
        done

        config_location=$(readlink $HOME/.ssh/config)
        log "Found that $HOME/.ssh/config the config file points to $config_location"
        echo -e "$new_config" > $config_location
        chmod 0644 $config_location
        chmod 0644 $HOME/.ssh/config
    fi
}

configure_dotfiles
unset -f configure_dotfiles
