# Check if zgen is installed
if [[ ! -d ~/.zgen ]]; then
  git clone https://github.com/tarjoilija/zgen.git ~/.zgen
  source "${HOME}/.zgen/zgen.zsh"
fi

# Completions must be included before sourcing zgen
autoload -U compinit
compinit -C
# Essential
source "${HOME}/.zgen/zgen.zsh"
# if the init script doesnt exist
if ! zgen saved; then

	# specify plugins here
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/vi-mode
	zgen load mafredri/zsh-async
	zgen load aperezdc/zsh-fzy
	zgen load zsh-users/zsh-history-substring-search
	zgen load zdharma/fast-syntax-highlighting
	zgen load zdharma/history-search-multi-word
	# zgen load sindresorhus/pure
	zgen load jackharrisonsherlock/common common.zsh-theme

	# generate the init script from plugins above
	zgen save
fi

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export PATH=$HOME/.local/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH

export RESTIC_PASSWORD_FILE=$HOME/.local/restic_pass
export AWS_SECRET_ACCESS_KEY=$(cat $HOME/.local/aws_secret_key)
export AWS_ACCESS_KEY_ID=$(cat $HOME/.local/aws_key)
export RESTIC_REPOSITORY=s3:https://s3.us-west-1.wasabisys.com/bckp

#PROMPT
# Color numbers cheatsheet
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
case `uname -s` in
	OpenBSD )
		# OSMASCOT=🐡
		#OSMASCOT="%{$fg[red]%}OpenBSD%{$reset_color%}"
		OSMASCOT='%B%F{black}%K{yellow} OpenBSD %f%k%b'
		;;
	Linux )
		OSMASCOT='%B%F{black}%K{214} Linux %f%k%b'
		#OSMASCOT=🐧
		;;
	Darwin )
		# OSMASCOT=🍎
		OSMASCOT='%B%F{white}%K{240} MacOS X %f%k%b'
	;;
esac

export OSMASCOT

COMMON_PROMPT_SYMBOL=" ❱ "
RPROMPT='$(common_git_status) $(vi_mode_prompt_info) $OSMASCOT'

zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:tab-title' format '$OSMASCOT %m: %s'
# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"
# case $TERM in
#     xterm*)
#         precmd () {print -Pn "\e]0;$OSMASCOT\a"}
#         ;;
# esac
# Prompt
autoload -U colors && colors


if [[ -z "$ZSH_SANEOPT_INSANITY" ]]; then
    ZSH_SANEOPT_INSANITY=1
fi

if [[ "$ZSH_SANEOPT_INSANITY" -gt 0 ]]; then
    # in order to use #, ~ and ^ for filename generation grep word
    # *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
    # don't forget to quote '^', '~' and '#'!
    setopt extended_glob

    # don't error out when unset parameters are used
    setopt unset
fi


###############
# Completions #
###############

# Arrow key menu for completions
zstyle ':completion:*' menu select

# Case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Aliases #
# Set up aliases
if [ -f ~/.aliases ]; then
	. ~/.aliases
fi
alias d='dirs -v'
alias ls='ls -Gahl'

for index ({1..9}) alias "$index"="cd +${index}"; unset index
# Autocomplete command line switches for aliases
setopt completealiases


# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
# bindkey "$terminfo[cuu1]" history-substring-search-up
# bindkey "$terminfo[cud1]" history-substring-search-down
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcuu1]" history-substring-search-up

bindkey "$terminfo[khome]" beginning-of-line
bindkey "$terminfo[kend]" end-of-line
bindkey '^R'  fzy-history-widget

bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# Use emacs keybinds, since they're modeless and closer to bash defaults
bindkey -v

# Variables #
export EDITOR=vi

#
# General
#

# no c-s/c-q output freezing
setopt noflowcontrol
# allow expansion in prompts
setopt prompt_subst
#
# Jobs
# Attempt to resume existing job before creating a new process.
setopt AUTO_RESUME
# Don't run all background jobs at a lower priority.
unsetopt BG_NICE
# Don't kill jobs on shell exit.
unsetopt HUP
# Don't report on jobs when shell exit.
unsetopt CHECK_JOBS
# display PID when suspending processes as well
setopt longlistjobs
# try to avoid the 'zsh: no matches found...'
setopt nonomatch
# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all
# not just at the end
setopt completeinword
# use zsh style word splitting
setopt noshwordsplit
# allow use of comments in interactive code
setopt interactivecomments
###########
# These are some more options that might warrant being on higher insanity levels,
# but since I don't use them... I'll leave them out for now

# watch for everyone but me and root
#watch=(notme root)
# automatically remove duplicates from these arrays
#typeset -U path cdpath fpath manpath

# History #
# number of lines kept in history
export HISTSIZE=10000
# number of lines saved in the history after logout
export SAVEHIST=10000
# location of history
export HISTFILE=~/.zsh_history
# save each command's beginning timestamp and the duration to the history file
setopt extended_history
# this is default, but set for share_history
setopt append_history
# append command to history file once executed
setopt inc_append_history
# import new commands from the history file also in other zsh-session
setopt share_history
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups
# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

# make cd push the old directory onto the directory stack.
#setopt auto_pushd
# avoid "beep"ing
#setopt nobeep
# don't push the same dir twice.
setopt pushd_ignore_dups
# * shouldn't match dotfiles. ever.
#setopt noglobdots
# Combine zero-length punctuation characters (accents)
# with the base character.
setopt combining_chars
# Enable comments in interactive shell.
setopt interactive_comments
# Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
setopt rc_quotes
# Don't print a warning message if a mail file has been accessed.
unsetopt mail_warning

# Directory options
# Auto changes to a directory without typing cd.
setopt auto_cd
# Push the old directory onto the stack on cd.
setopt auto_pushd
# Do not store duplicates in the stack.
setopt pushd_ignore_dups
# Do not print the directory stack after pushd or popd.
setopt pushd_silent
# Push to home directory when no argument is given.
setopt pushd_to_home
# Change directory to a path stored in a variable.
setopt cdable_vars
# Write to multiple descriptors.
setopt multios
# Use extended globbing syntax.
setopt extended_glob
# Do not overwrite existing files with > and >>.
# Use >! and >>! to bypass.
unsetopt clobber

# Stop higlighting pated text
zle_highlight+=(paste:none)
