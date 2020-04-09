# Extra-simple prompt for Emacs' tramp
if [[ $TERM == "dumb" ]]; then
    unsetopt zle
    PS1='$ '
    return
fi

autoload -Uz compinit promptinit
compinit
promptinit

# This will set the default prompt to the walters theme
setopt prompt_subst

PROMPT='$vcs_info_msg_0_(%(!.%F{red}#.%F{green}%%)%f) %F{yellow}%~%f %F{magenta}❯%f '

function preexec() {
    timer=$SECONDS
}

function precmd() {
    vcs_info
    ELAPSED=""
    if [ $timer ]; then
	TIME=$(($SECONDS-$timer))
	if [[ $TIME -gt 0 ]]; then
	    ELAPSED="exec: %F{yellow} $TIME s%f "
	fi
    fi
    unset timer TIME
}

case `uname -s` in
	OpenBSD )
		OSMASCOT=🐡
		#OSMASCOT="%{$fg[red]%}OpenBSD%{$reset_color%}"
		OS='%B%F{black}%K{yellow} OpenBSD %f%k%b'
		;;
	Linux )
		OSMASCOT=🐧
		OS='%B%F{black}%K{214} Linux %f%k%b'
		;;
	Darwin )
		OSMASCOT=🍎
		OS='%B%F{white}%K{240} MacOS X %f%k%b'
	;;
esac

export OS OSMASCOT

RPROMPT='%(?.%F{green}[✓]%f.%F{red}[%?]%f) ${ELAPSED}${OSMASCOT}'


autoload -Uz vcs_info
# this function will be called to set the info
# precmd_vcs_info() { 
#   vcs_info
#   update_terminal_tab_title $vcs_info_msg_0_
# }

# RPROMPT='%F{240}$vcs_info_msg_0_%f'
# PROMPT='\$vcs_info_msg_0_%# '

# enables checking for staged/unstaged
zstyle ':vcs_info:*' check-for-changes true

# set the format for $vcd_info_msg_0 string
# %s: vcs service (in our case 'git')
# %r: repository name
# %b: branch name
# %u: 'U' if there are unstaged files
# %c: 'S' if there are staged, but uncommitted files

zstyle ':vcs_info:git:*' formats $'Git: %F{green}%r%f %F{red}%b%f %u%c\n'

# enable just git
zstyle ':vcs_info:*' enable git

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information

autoload add-zsh-hook
#add-zsh-hook precmd precmd_vcs_info

# COMMON_PROMPT_SYMBOL=" ❱ "
