# -*- mode: shell-script -*-
# -*- coding: utf-8 -*-

autoload -Uz colors
colors

setopt prompt_subst
case ${UID} in
  0)
  PROMPT="%{$fg_bold[green]%}%m%{$fg_bold[red]%}#%{$reset_color%} "
  PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
  ;;
  *)
  PROMPT="%{$fg_bold[cyan]%}%m%{$fg_bold[white]%}%%%{$reset_color%} "
  PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
  ;;
esac

RPROMPT="%{$fg_bold[white]%}[%{$reset_color%}%{$fg[cyan]%}%~%{$reset_color%}%{$fg_bold[white]%}]%{$reset_color%}"
SPROMPT="%{$fg_bold[red]%}correct%{$reset_color%}: %R -> %r ? "

autoload -Uz compinit
compinit

setopt auto_cd
setopt auto_pushd
setopt auto_list
setopt list_packed
setopt list_types
setopt pushd_ignore_dups
setopt correct
setopt complete_aliases
setopt nonomatch

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select

HISTFILE=~/.zsh_histfile
HISTSIZE=10000
SAVEHIST=10000

if [ $UID = 0 ]; then
    unset HISTFILE
    SAVEHIST=0
fi

setopt share_history

setopt hist_ignore_all_dups

setopt hist_ignore_dups

setopt hist_save_no_dups

if [ -f ~/.dir_colors ]; then
    eval `dircolors -b ~/.dir_colors`
fi

zstyle ':completion:*:sudo:*' list-colors ${(s.:.)LS_COLORS}

alias la='ls -aF --show-control-char --color=always'
alias ls='ls --show-control-char --color=always'
alias open='gnome-open'
alias start='gnome-open'

function chpwd() {ls -v -F --color=auto}

function google() {
    local str opt
    if [ $# != 0 ]; then
	for i in $*; do
	    str="$str+$i"
	done
	str=`echo $str | sed 's/^\+//'`
	opt='search?num=50&hl=ja&lr=lang_ja'
	opt="${opt}&q=${str}"
    fi
    w3m http://www.google.co.jp/$opt
}

function cdup() {
    echo
    cd ..
    zle reset-prompt
}
zle -N cdup
bindkey '\^' cdup

export LANG=ja_JP.UTF-8
export SVN_SSH='ssh -l t-ito'

if [ -d ~/prog/kasabake ]; then
    export PATH=$PATH:~/prog/kasabake
    if [ -f ~/.zshrc.kasabake.util ]; then
	source ~/.zshrc.kasabake.util
    else
	echo "not initialize zsh-utils yet. execute kasabake zsh-utils"
    fi
fi
