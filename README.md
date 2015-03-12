# DotFiles!
- Anything with a .syml extension will have a dot added to the front of it and it will be symlinked to your home dir
- Anything with a .bash will be sourced into your environment by main.sh in the bash folder
- Anything with a .sshc will automatically be added together and used as a config file for ssh
- Anything with a .vimc will be used as vim configuration
- everything in the osx folder will only be used on mac
- The bin directory will be added to your path automatically
- Type alias to see a list of the helpful aliases

# How does it work?
1. source ~/.dotfiles/dot
2. Magic

# Install
1. git clone https://github.com/BrandonOCasey/.dotfiles ~/.dotfiles
2. source ~/.dotfiles/dot

# Re-Install without logout
* run dot, source ~/.bash_profile, or source ~/.dotfiles/dot

# TODO
* Fix bash ctrl + R issues
* Better dir colors on mac
* add support for custom folder overriding dist
* Mac specific folder
* git push simple but only on certain versions
* Sub section comments need to look better
* usage test, and --help for functions
* split hosts to multiple files
* Mark Control+C/"" as no in ask_user
* Run todos to see vim fixes
* Bash home to start of terminal newline and end to end of terminal newline (not to start/end of command)
* Simplify Binary install
* Find out how to fix incorrect tab issues in vim
* git/svn and re-source dot if there was an update
* vim lag mac
* PHP/Ruby vim lag
* Themes
* fix d1000 down in vim
* Fix vim slow on large lines
* Dont try to install if not avilable after the first time
* wrap all installs in functions
* unset uneeded lib functions
* Fix bmv
* Cleanup lib.sh
* Smart Home doesn't work on putty?
* Unit tests
* Debug with -x and -u
* Can we do set -e and set -u by default? with error handles
* Improve the log
* Move log lines out of functions if possible
* .syml extension in a folder to grab dir stucture and place all files symlinked under that structure dest/svn/subversion/{config, .syml} => .subversion/config
