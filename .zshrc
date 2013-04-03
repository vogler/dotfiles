#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
alias v='vim'
alias packer='packer --noedit'
alias ocaml='rlwrap -H ~/.ocaml_history -D 2 -i -s 10000 ocaml'
function cwdsh(){ if [[ -z $2 ]]; then eval $1; else pu $2; eval $1; po; fi }
alias lh='cwdsh "ls -d .*"'
alias lah='cwdsh "ls -lhd .*"'
unalias top # prezto aliases it to htop if it's installed
alias topm='top -o %MEM'
function psmem(){ # e.g. psmem chrome
    top -bn 1 | grep $1 | cut -c32-36 - | awk '{s+=$1} END {print s}'
}
function archive(){ # save file(s) as (encrypted) archive to dropbox
    dst=~/Dropbox/$1.7z
    rm -f $dst
    7z a -mhe=on -p -l $dst $* # if a password is given, the header will also be encrypted. resolves symlinks.
}


# Credits to npm's. Awesome completion utility.
#
# Bower completion script, based on npm completion script.

###-begin-bower-completion-###
#
# Installation: bower completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: bower completion > /usr/local/etc/bash_completion.d/npm
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _bower_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           bower completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _bower_completion bower
elif type compdef &>/dev/null; then
  _bower_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 bower completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _bower_completion bower
elif type compctl &>/dev/null; then
  _bower_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       bower completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _bower_completion bower
fi
###-end-bower-completion-###

