#!/usr/bin/env sh

COMMAND=$1

if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

message() {
  echo "${GREEN}$1${NORMAL}"
}


install_ansible() {
  message "Installing Xcode..."
  xcode-select --install

  message "Installing pip..."
  sudo easy_install pip

  message "Installing Ansible..."
  sudo pip install ansible
}

install_requirements() {
  message "Installing Ansible requirements..."
  ansible-galaxy install -r requirements.yml
}

run() {
  message "Run Ansible..."
  ansible-playbook -i hosts main.yml
}


main() {
  if [ "$COMMAND" = "ansible" ]; then
    install_ansible
  elif [ "$COMMAND" = "requirements" ]; then
    install_requirements
  elif [ "$COMMAND" = "" ]; then
    run
  elif [ "$COMMAND" = "all" ]; then
    install_ansible
    install_requirements
    run
  fi
}

main
