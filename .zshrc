autoload -Uz compinit promptinit
compinit
promptinit

# This will set the default prompt to the walters theme
setopt prompt_subst

# History settings
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
# bindkey "$terminfo[cuu1]" history-substring-search-up
# bindkey "$terminfo[cud1]" history-substring-search-down
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey '^R'  fzy-history-widget
# bindkey '^[[A' history-substring-search-up
# bindkey '^[OA' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
# bindkey '^[OB' history-substring-search-down
 
export HISTFILE=~/.zsh_history
export HISTSIZE=10000          # number of lines kept in history
export SAVEHIST=10000          # number of lines saved after logout
setopt extended_history          # save timestamp and the duration
setopt append_history            # this is default, but set for share_history
setopt inc_append_history        # append command to history file once executed
setopt share_history # import new commands from other zsh-session
# If a new command line being added to the history list duplicates an older
setopt histignorealldups
# remove command lines from the history list when the first character on the
setopt histignorespace

setopt extended_glob # rm -- ^*.dmg -- rm all files except .dmgs
# HISTCHARS='!^#'
# HISTCMD=1304
# HISTFILE=~/.zsh_history

# histchars='!^#'
# history
# historywords

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

# Emacs tramp fix
if [[ "$TERM" == "dumb" ]]; then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  # fix for the Odd ^[[2004h symbols
  # https://github.com/syl20bnr/spacemacs/issues/3035
  unset zle_bracketed_paste
  PS1='$ '
  RPROMPT=''
fi
