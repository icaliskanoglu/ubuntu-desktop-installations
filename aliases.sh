acs() {
    apt-cache search $1 | grep $2
}

mcd() {
  mkdir -p "${1:?Need to specify an argument}" && cd "$1"
}

retry() {
  while true; do $@; sleep 1; done
}

port() {
  ps="$(sudo lsof -t -i:"$1")"
  if [[ -z "$ps" ]]; then
    echo "no processes found"
  else
    echo "$ps"
  fi
}

portkill() {
  ps="$(sudo lsof -t -i:"$1")"
  if [[ -z "$ps" ]]; then
    echo "no processes found"
  else
    sudo kill -9 "$ps" && echo "$ps"
  fi
}

# convenience aliases
alias install="sudo apt-get install"
alias remove="sudo apt-get remove --purge"
alias cd..='cd ..'
alias cd...='cd ../..'
alias ls='ls --color'
alias l='ls -lF'
alias dir='ls'
alias la='ls -lah'
alias ll='ls -l'
alias ls-l='ls -l'
alias c='xclip -sel clip'
alias p='xclip -sel clip -o'
alias pt='xclip -sel clip -o | tee'
alias t='tee'
alias idea='idea .'
alias code='code .'