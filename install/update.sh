#! /bin/sh

if [ -d "$DOTFILES_ROOT/.svn" ]; then
    log "Async update for SVN"
    async_command "svn up $DOTFILES_ROOT"
fi
if [ -d "$DOTFILES_ROOT/.git" ]; then
    log "Async update for GIT"
    async_command "(cd $DOTFILES_ROOT && git pull)"
fi
