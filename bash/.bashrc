
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='exa -la'

status_code() {
  if [ $? -eq 0 ]; then echo -e "\e[42m\e[30m 👍 \e[m"; else echo -e "\e[41m\e[30m 👎 $? \e[m"; fi
}
PS1="\e[43m\e[30m \d, \t \e[m\$(status_code)\e[44m\e[30m \u@\h \e[m\e[46m\e[30m \w \e[m\n$ "

# enable vi mode
set -o vi

[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
