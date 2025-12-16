#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# init starship
eval "$(starship init bash)"

# mise
eval "$(~/.local/bin/mise activate bash)"

# elixir iex shell history
export ERL_AFLAGS="-kernel shell_history enabled"
. "$HOME/.cargo/env"

# fly io cli
export FLYCTL_INSTALL="/home/fabri/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# gpg key to sign commits
export GPG_TTY=$(tty)

# zed editor
alias zed='zeditor'

# bin
export PATH="~/.local/bin:$PATH"
