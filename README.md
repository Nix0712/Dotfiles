
# Hyprland Setup on Arch Linux

This guide provides detailed instructions for setting up Hyprland on Arch Linux with NVIDIA support, SDDM, and additional essential packages. Follow the steps below to configure your environment effectively.

## Prerequisites

- Arch Linux installed and updated
- Basic familiarity with terminal commands

## Step 1: Install Required Packages

Run the following command to install Hyprland, a Wayland compositor, along with other essential packages:

```bash
sudo pacman -S hyprland alacritty nemo wofi polkit hyprpaper waybar sddm git nvim pulseaudio qt6 zsh alsa-utils
```

### Package Overview:
- **Hyprland**: A dynamic Wayland compositor.
- **Alacritty**: A lightweight and fast terminal emulator.
- **Nemo**: File manager.
- **Wofi**: A Wayland-compatible application launcher.
- **Polkit**: Authentication agent for elevated permissions.
- **Hyprpaper**: Wallpaper manager for Hyprland.
- **Waybar**: Status bar for Wayland.
- **SDDM**: Display manager.
- **Git**: Version control system.
- **Neovim (nvim)**: Advanced text editor.
- **PulseAudio**: Sound system.
- **Qt6**: Required libraries for some applications.

## Step 2: Install Yay (Yet Another Yaourt)

Yay is an AUR helper that simplifies package management from the Arch User Repository (AUR).

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Step 3: Configure Hyprland for NVIDIA

To ensure Hyprland works well with NVIDIA graphics, follow these steps:

1. **Install NVIDIA drivers**:

   ```bash
   sudo pacman -S nvidia nvidia-utils nvidia-settings
   ```

Edit /etc/mkinitcpio.conf. In the MODULES array, add the following module names:

```bash
MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)
```

Then, create and edit /etc/modprobe.d/nvidia.conf. Add this line to the file:
```bash
options nvidia_drm modeset=1 fbdev=1
```

Lastly, rebuild the initramfs with sudo mkinitcpio -P, and reboot.

2. **Change Hyprland config**

In hyprland config add following:
```bash
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia

cursor {
    no_hardware_cursors = true
}
```

3. **Restart Hyprland** to apply changes.

## Step 4: Install Additional Packages with Yay

Use Yay to install additional packages like 7-zip:

```bash
yay -S 7-zip ttf-jetbrains-mono-nerd
```

## Step 5: Set Up SDDM

1. **SDDM Configuration**:

Move config files from sddm folder (we are in dotfiles folder):

```bash
sudo cp ./sddm/sddm.conf /etc/
sudo cp -r ./sddm/clairvoyance /etc/usr/shere/sddm/themes
```

```bash
sudo systemctl enable sddm
```
## Step 6: Rest of the configurations

Copy the following code:
```bash
sudo cp -r ./alacritty ~/.config/
sudo cp -r ./hypr ~/.config/
sudo cp -r ./waypaper ~/.config/
sudo cp -r ./wofi ~/.config/
sudo cp -r ./Pictures ~/
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo systemctl enable pulseaudio
```

