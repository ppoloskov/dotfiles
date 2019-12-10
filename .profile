# $OpenBSD: dot.profile,v 1.5 2018/02/02 02:29:54 yasuoka Exp $
#
# sh/ksh initialization

PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games
export PATH HOME TERM
export HISTFILE=~/.sh_history
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

export PATH=$PATH:$HOME/.local/bin

NORM="\033[0m"


case $USER in
        root )
                USER_COL="\033[31m" ;;
esac

# case `uname -s` in
#     OpenBSD )
#         export PS1='\[ 🐡\] $USER_COL${USER}$NORM @\e[0;32m\]${HOST}\[\e[0m\] \[\e[0;36m\]${PWD##${HOME}/}\[\033[0m\] \$ '
#         ;;
#     *)
#         export PS1='\u@\h \w \$ '
#         ;;
# esac

