#!/usr/bin/env bash
echo "Installing Personal Ubuntu"


BASEDIR=$(dirname "$0")

install_aliases(){
    if [[ ! -d "$HOME/.env" ]]; then
        mkdir "$HOME/.env"
    fi 

    cp "$BASEDIR/aliases.sh" "$HOME/.env/aliases.sh"
}
#---------------------------------------------------------

install_defauls(){
    echo "Installing defaults"
    sudo apt update && sudo apt upgrade && sudo ubuntu-drivers autoinstall
    sudo apt install git tilda curl htop net-tools vlc apt-transport-https gnupg2 unzip -y
}
#---------------------------------------------------------

install_chrome(){
    echo "Installing Chrome"
    curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome-stable_current_amd64.deb  && \
    sudo apt install /tmp/google-chrome-stable_current_amd64.deb
}
#---------------------------------------------------------

install_opera(){
    echo "Installing Opera"
    wget -qO - https://deb.opera.com/archive.key | sudo apt-key add - && \
    sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free' && \
    sudo apt update && sudo apt install opera-stable -y
}
#---------------------------------------------------------

install_transmission(){
    echo "Installing transmission"
    sudo add-apt-repository ppa:transmissionbt/ppa
    sudo apt-get update
    sudo apt-get install transmission-gtk transmission-cli transmission-common transmission-daemon -y
}

#---------------------------------------------------------
install_spotify(){
    echo "Installing spotify"
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 4773BD5E130D1D45
    sudo add-apt-repository "deb http://repository.spotify.com stable non-free"
    sudo apt install spotify-client
}

#---------------------------------------------------------
install_ssh(){
    echo "Installing ssh server"
    sudo apt install -y openssh-server
    sudo systemctl status ssh
    sudo ufw allow ssh
}

#---------------------------------------------------------


install_pip(){
    echo "Installing pip3"
    sudo apt install -y python3-pip
    sudo apt install -y build-essential libssl-dev libffi-dev python3-dev
    sudo apt install -y python3-venv

    echo "alias python=\"python3\"" >> "$HOME/.env/aliases.sh"
    echo "alias pip=\"pip3\"" >> "$HOME/.env/aliases.sh"

    pip3 install virtualenv
    echo "export PATH=\"\$PATH\:\${HOME}/.local/bin\"" >> "$HOME/.env/aliases.sh"
    source "$HOME/.env/aliases.sh"
}

#---------------------------------------------------------

install_go(){
    echo "installing golang"
    curl -L https://golang.org/dl/go1.15.linux-amd64.tar.gz -o /tmp/go1.15.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf /tmp/go1.15.linux-amd64.tar.gz
    echo "export GOPATH=\"\${HOME}/go\"" >> "$HOME/.env/aliases.sh"
    echo "export PATH=\"\$PATH\:/usr/local/go/bin\"" >> "$HOME/.env/aliases.sh"
}

#---------------------------------------------------------
install_java(){
    echo "installing Java"
    sudo apt install openjdk-11-jdk openjdk-14-jdk openjdk-8-jdk -y
    echo "export JAVA_HOME_11=\"/usr/lib/jvm/java-11-openjdk-amd64\"" >> "$HOME/.env/aliases.sh"
    echo "export JAVA_HOME_14=\"/usr/lib/jvm/java-14-openjdk-amd64\"" >> "$HOME/.env/aliases.sh"
    echo "export JAVA_HOME_8=\"/usr/lib/jvm/java-8-openjdk-amd64\"" >> "$HOME/.env/aliases.sh"
    echo "export JAVA_HOME=\"\${JAVA_HOME_8}\"" >> "$HOME/.env/aliases.sh"
}

#---------------------------------------------------------

install_rust(){
    echo "install rust"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    echo "source \"\$HOME\"/.cargo/env" >> "$HOME/.env/aliases.sh"
}

#---------------------------------------------------------

install_platformio(){
    echo "Installing PlatformIO"
    virtualenv ${HOME}/.platformio/penv
    pip3 install -U platformio
    code --install-extension platformio.platformio-ide
}


#------------------------------------------------------------
install_terraform(){
    echo "Installing Terraform"
    curl -L https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip -o /tmp/terraform_0.12.26_linux_amd64.zip
    unzip -o /tmp/terraform_0.12.26_linux_amd64.zip -d /usr/local/bin/
    terraform --version
    code --install-extension mauve.terraform
}

#-----------------------------------------------------------

install_kubectl(){
    echo "####Installing kubectl####"
    sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    echo "alias k=\"kubectl\"" >> "$HOME/.env/aliases.sh"
}

#-----------------------------------------------------------

install_virtualbox(){
    echo "####Installing virtualbox####"
    sudo apt install virtualbox -y
}


#-----------------------------------------------------------

install_docker(){
    echo "Installing Docker"
    sudo apt update && \
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    sudo apt update && \
    sudo apt-cache policy docker-ce && \
    sudo apt install docker-ce -y

    sudo systemctl status docker --no-pager

    #run docker without sudo

    echo "Configuring docker to run without sudo"
    sudo usermod -aG docker ${USER}
    newgrp docker

    code --install-extension ms-azuretools.vscode-docker
}



#-----------------------------------------------------------

install_minikube(){
    echo "####Installing minikube####"

    minikube delete --purge 2>&1 >/dev/null 

    curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /tmp/minikube \
    && chmod +x /tmp/minikube
    sudo mkdir -p /usr/local/bin/ && \
    sudo install /tmp/minikube /usr/local/bin/ 
    minikube start --vm-driver=docker
    minikube status
    code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
}

#-----------------------------------------------------------

install_vscode(){
    echo "Installing VSCode"

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt update && \
    sudo apt install code -y # or code-insiders

    echo "export EDITOR=code" >> "$HOME/.env/aliases.sh"
}

#----------------------------------------------------------

install_arduinoide(){
    echo "Installing ArduinoIDE"
    curl -L https://downloads.arduino.cc/arduino-1.8.13-linux64.tar.xz -o /tmp/arduino-1.8.13-linux64.tar.xz
    tar xvf /tmp/arduino-1.8.13-linux64.tar.xz -C /tmp
    sudo /tmp/arduino-1.8.13/install.sh
}

#----------------------------------------------------------

install_zsh(){
    echo "Installing ZSH"
    sudo apt update && sudo apt upgrade && \
    sudo apt install zsh powerline fonts-powerline -y && \
    sudo apt autoremove -y

    echo "Installing OH-MY-ZSH"

    export RUNZSH=no

    rm -rf "$HOME/.oh-my-zsh" && \
    curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o /tmp/oh-my-zsh-install.sh && \
    chmod +x /tmp/oh-my-zsh-install.sh && \
    /tmp/oh-my-zsh-install.sh

    echo "Installing Zsh Plugins"
    rm -rf "$HOME/.zsh/zsh-syntax-highlighting" && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting" --depth 1

    rm -rf "$HOME/.zsh/zsh-autosuggestions" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.zsh/zsh-autosuggestions"

    rm -rf "$HOME/.zsh/zsh-history-substring-search" && \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git "$HOME/.zsh/zsh-history-substring-search"

    echo "source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
    echo "source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
    echo "source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" >> "$HOME/.zshrc"
    echo "source $HOME/.env/aliases.sh" >> "$HOME/.zshrc"

    echo "Starting ZSH"
    exec zsh -l
}

install_tools(){
    install_aliases
    install_defauls
    install_chrome
    install_opera
    install_transmission
    install_spotify
    install_ssh
}

install_langs(){
    install_pip
    install_go
    install_java
    install_rust
}

install_ides(){
    install_vscode
    install_platformio
    install_arduinoide
}

install_dev_tools(){
    install_langs
    install_ides
    install_terraform
    install_virtualbox
    install_docker
    install_minikube
    install_kubectl
}

install_all(){
    install_tools
    install_dev_tools
}
main(){
    func="install_$1"
    $func
}

main "$@"
