# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# color scheme for ls
eval `dircolors ~/.config/dircolors`

alias ls='ls --color=auto'
alias ll='ls -la'

status_code() {
  if [ $? -eq 0 ]; then echo -e "\e[32m✓\e[m"; else echo -e "\e[31m✗ ($?)\e[m"; fi
}
PS1="\e[1m[ \d, \t |\e[m \$(status_code) \e[1m| \u@\h | \w ]\e[m\n$ "

# TODO: remove yarn?
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
