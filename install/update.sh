#! /bin/sh

if [ -d "$DOTFILES_ROOT/.svn" ]; then
    log "Async update for SVN"
    svn up "$DOTFILES_ROOT" | log 2>/dev/null >/dev/null &
    disown
fi
if [ -d "$DOTFILES_ROOT/.git" ]; then
    log "Async update for GIT"
    git --git-dir=$DOTFILES_ROOT/.git --work-tree=$DOTFILES_ROOT pull 2>&1 | log 2>/dev/null 1>/dev/null &
    disown
fi
