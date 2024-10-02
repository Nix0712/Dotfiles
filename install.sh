#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
ORANGE='\033[38;5;214m'
CYAN='\033[1;36m'

default_installation(){
  cd ~
  packages=''
  #Getting all packages from installation_pkgs.txt
  #This is done for the practice purposes
  while IFS= read -r line; do
    packages="$packages$line "
  done < installation_pkgs.txt
  echo $packages 

  if ! command -v yay 2>&1 >/dev/null
  then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    echo "Yay installed successfully"
    cd ..
    rm -rf yay
  fi
  yay -S $packages
}

echo "Welcome to configuration installer!"
echo "Choose one of the option to install"
echo -e "${CYAN}[1]${RC} Install configuration"
echo -e "${CYAN}[q]${RC} Abort the installation"

while true; do
  echo -n "Choose one of the option: "
  read installer_process
  case $installer_process in
    "1")
      echo -e "${GREEN}Starting default installation...${RC}"
      default_installation
      break
      ;;
    "q")
      echo -e "Aborting insallation"
      break
      ;;
    *)
      echo -e "${RED}Unknown input, please select valid option${RC}"
      ;;
  esac
done



