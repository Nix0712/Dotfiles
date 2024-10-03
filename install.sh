#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
ORANGE='\033[38;5;214m'
CYAN='\033[1;36m'

install_processor_drivers(){
  echo "Choose type of processor you are using: "
  echo -e "${CYAN}[1]${RC} AMD porcessor"
  echo -e "${CYAN}[2]${RC} Intel processor"
  echo -e "${CYAN}[3]${RC} Skip processor driver installation"
  while true; do
    echo -n "Choose one of the option: "
    read driver_option 
    case $driver_option in
      "1")
        echo -e "${GREEN}Installing AMD dirver${RC}"
        yay -S amd-ucode 
        break
        ;;
      "2")
        echo -e "${GREEN}Installing intel driver...${RC}"
        yay -S intel-ucode
        break
        ;;
      "3")
        echo -e "${YELLOW}Skiping processor driver installation...${RC}"
        break
      *)
        echo -e "${RED}Unknown input, please select valid option${RC}"
        ;;
    esac
  done
  echo -e "${GREEN}Processor dirvers installation finished!${RC}"
}

configure_nvidia(){
  echo "Setting up nvidia dirvers"
  if ! command -v mkinitcpio 2>&1 >/dev/null; then
    echo -e "${CYAN}installing mkinitcpio...${RC}"
    yay -s mkinitcpio 
    echo -e "${GREEN}mkinitcpio installed!${RC}"
  fi 
  sudo sed -i '/^MODULES=/ s/(\(.*\))/(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee /etc/modprobe.d/nvidia.conf
  sudo mkinitcpio -P
  cat <<EOL >> ~/.config/hypr/hyprland.conf
  env = LIBVA_DRIVER_NAME,nvidia
  env = GBM_BACKEND,nvidia-drm
  env = __GLX_VENDOR_LIBRARY_NAME,nvidia

  cursor {
      no_hardware_cursors = true
  }
  EOL
}

install_nvidia_drivers(){
  nvidia_present="n" 
  echo -n "Do you have Nvidia graphics card? ${CYAN}[y/N]${RC}"
  if [ "$nvidia_present" = "y" ]; then
    echo -e "Installing Nvidia driver..."
    yay -S nvidia nvidia-utils nvidia-settings
    configure_nvidia
    echo -e "${GREEN}Nvidia drivers installed${RC}"
  else
    echo -e "${GREEN}Skipping Nvidia installation${RC}"
  fi
}

create_soft_links(){
  if command -v stow 2>&1 >/dev/null; then
    echo -e "${CYAN}Linking files...${RC}"
    stow . --adopt
    echo -e "${GREEN}All file are linked and ready!${RC}"
  else
    echo -e "${RED}LINKING FAILE!${RC}"
  fi   
}

default_installation(){
  cd ~
  packages=''
  #Getting all packages from installation_pkgs.txt
  #This is done for the practice purposes
  while IFS= read -r line; do
    packages="$packages$line "
  done < installation_pkgs.txt
  echo $packages 

  if ! command -v yay 2>&1 >/dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    echo "Yay installed successfully"
    cd ..
    rm -rf yay
  fi
  yay -S $packages
  create_soft_links
  install_processor_drivers
  install_nvidia_drivers
}

echo "${GREEN}Welcome to configuration installer!${RC}"
echo "${YELLOW}Choose one of the option to install${RC}"
echo -e "${CYAN}[1]${RC} Install configuration"
echo -e "${CYAN}[q]${RC} Abort the installation"

while true; do
  echo -n "Choose one of the option: "
  read installer_process
  case $installer_process in
    "1")
      echo -e "${GREEN}Starting default installation...${RC}"
      default_installation
      reboot
      break
      ;;
    "q")
      echo -e "${YELLOW}Aborting insallation${RC}"
      break
      ;;
    *)
      echo -e "${RED}Unknown input, please select valid option${RC}"
      ;;
  esac
done
