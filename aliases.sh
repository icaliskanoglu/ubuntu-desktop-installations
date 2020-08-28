alias install="sudo apt-get install"

alias remove="sudo apt-get remove --purge"

acs() {
    apt-cache search $1 | grep $2
}
