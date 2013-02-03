#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="vim"
__git_ps1 () 
{ 
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
	if [ -n "$b" ]; then
		printf "(%s)" "${b##refs/heads/}";
	fi
}
CBR="\[\033[1;31m\]"
CBY="\[\033[1;33m\]"
CDY="\[\033[0;33m\]"
CBG="\[\033[1;32m\]"
RESET="\[\033[0;0;00m\]"
# http://railstips.org/blog/archives/2009/02/02/bedazzle-your-bash-prompt-with-git-info/
PS1="$CBY\w$CDY\$(__git_ps1)$CBG $RESET"
#PS1='[\u@\h \W]\$ '
alias ls='ls --color=auto'
eval $(dircolors -b)
alias l='ls'
alias la='ls -A'
alias ll='ls -lAh'
alias grep='grep -n --color=auto'
alias v='vim'
alias p='sudo pacman -S'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# GIT
# done by package bash-completion
# source /usr/share/git/completion/git-completion.bash
alias gs='git status'
alias gl='git log'
alias gb='git branch'
alias gfu='git fetch upstream'
alias gmu='git merge upstream/master'
# alias gru='git pull --rebase upstream master'
alias gd='git diff'
alias ga='git add -A'
alias gc='git commit'
alias gp='git push'

alias ocaml='rlwrap -H /home/ralf/.ocaml_history -D 2 -i -s 10000 ocaml'
# alias ssh='eval $(/usr/bin/keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa) && ssh'

man() {
        env \
                LESS_TERMCAP_mb=$(printf "\e[1;31m") \
                LESS_TERMCAP_md=$(printf "\e[1;31m") \
                LESS_TERMCAP_me=$(printf "\e[0m") \
                LESS_TERMCAP_se=$(printf "\e[0m") \
                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
                LESS_TERMCAP_ue=$(printf "\e[0m") \
                LESS_TERMCAP_us=$(printf "\e[1;32m") \
                        man "$@"
}

