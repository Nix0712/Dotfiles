#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
ORANGE='\033[38;5;214m'
CYAN='\033[1;36m'

install_yay() {
  # Check if yay is installed
  if ! command -v yay &>/dev/null; then
    echo "${ORANGE}yay not found. Installing yay...${RC}"
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
  else
    echo "${GREEN}yay is already installed.${RC}"
  fi
}

hyprland_nvidia_support() {
  # Modify hyprland.conf
  {
    echo "env = LIBVA_DRIVER_NAME,nvidia"
    echo "env = GBM_BACKEND,nvidia-drm"
    echo "env = __GLX_VENDOR_LIBRARY_NAME,nvidia"
  } >>./.config/hypr/hyprland.conf

  # Enable nvidia in kernel
  sudo sed -i '/^MODULES=/ s/(\(.*\))/(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee /etc/modprobe.d/nvidia.conf
}

enable_services() {
  sudo systemctl enable sddm
  sudo systemctl start sddm
}

install_processor_drivers() {
  echo "Choose type of processor you are using: "
  echo -e "${CYAN}[1]${RC} AMD porcessor"
  echo -e "${CYAN}[2]${RC} Intel processor"
  echo -e "${CYAN}[3]${RC} Skip processor driver installation"
  while true; do
    echo -n "Choose one of the option: "
    read -r driver_option
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
      ;;
    *)
      echo -e "${RED}Unknown input, please select valid option${RC}"
      ;;
    esac
  done
  echo -e "${GREEN}Processor dirvers installation finished!${RC}"
}

configure_nvidia() {
  echo "Setting up nvidia dirvers"
  if ! command -v mkinitcpio &>/dev/null; then
    echo -e "${CYAN}installing mkinitcpio...${RC}"
    yay -s mkinitcpio
    echo -e "${GREEN}mkinitcpio installed!${RC}"
  fi

  sudo mkinitcpio -P
}

install_nvidia_drivers() {
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

create_soft_links() {
  if command -v stow &>/dev/null; then
    echo -e "${CYAN}Linking files...${RC}"
    stow . --adopt
    echo -e "${GREEN}All file are linked and ready!${RC}"
  else
    echo -e "${RED}LINKING FAILE!${RC}"
  fi
}

default_installation() {
  install_yay

  # Check for packages file and install all packages
  if [[ -f pacakages ]]; then
    echo "${GREEN} Installing packages${RC}"
    yay -S - <packages
  else
    echo "${RED} Packages file not found${RC}"
  fi

  install_processor_drivers
  install_nvidia_drivers
  create_soft_links
  enable_services
}

echo "${GREEN}Welcome to configuration installer!${RC}"
echo "${YELLOW}Choose one of the option to install${RC}"
echo -e "${CYAN}[1]${RC} Install configuration(Nvidia)"
echo -e "${CYAN}[q]${RC} Abort the installation"

while true; do
  echo -n "Choose one of the option: "
  read -r installer_process
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
    break
    ;;
  esac
done
