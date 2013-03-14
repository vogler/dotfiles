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
alias ocaml='rlwrap -H /home/ralf/.ocaml_history -D 2 -i -s 10000 ocaml'

# OPAM configuration
. /home/ralf/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
