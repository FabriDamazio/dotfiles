# Installation script

# On Arch Linux
# ---- setting keymaps:
# loadkeys br-abnt
# ---- list the disks:
# fdisk -l
# ---- creating partitions:
# fdisk <YOUR_BLOCK_DEVICE>
# n (to create new partition)
# t (to change partition type)
# ---- create 3 partitions:
# 1 - 1Gb size - EF (uefi) - for boot
# 2 - 50gb - 83 (linux Ext4) - for root
# 3 - the rest - 83 (linux Ext4) - for home
# ---- formating disks
# mkfs.fat -F32 <BOOT PARTITION> (e.g /dev/sda1)
# mkfs.ext4 <ROOT PARTITION>
# mkfs.ext4 <HOME PARTITION>
# ---- mouting partitions
# mount <ROOT PARTITION> /mnt
# mount --mkdir <BOOT PARTITION> /mnt/boot
# mount --mkdir <HOME PARTITION> /mnt/home
# ---- internet connection (just for WIFI, ethernet skip it)
# iwctl
# station list # this will show youre wireless cards usually it will be wlan0
# station wlan0 get-networks
# station wlan0 connect YOUR_WIFI_NETWORK
# enter the password when prompted
# you should be connected soon
# press CTRL C to leave
# ---- install the base system
# pacman -Syy
# pacstrap -K /mnt base linux linux-firmware
# ---- enter the new system
# arch-chroot /mnt
# ---- generate the swapfile
# mkswap -U clear --size 16G --file /swapfile
# swapon /swapfile
# ---- exit the system
# exit
# ---- generate the FSTAB file
# genfstab -U /mnt >> /mnt/etc/fstab
# ---- back to system
# arch-chroot /mnt
# ---- installing pacman packages
# pacman -S sudo vi iwd dhcpcd networkmanager 
# ---- setting timezone
# timedatectl set-timezone America/Sao_Paulo
# ---- setting clock
# hwclock --systohc
# timedatectl set-ntp true
# ---- locales (uncomment us,pt_BR, ja_JP and  ZN_ch)
# vi /etc/locale.gen
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# ---- setting hostname
# echo archlinux > /etc/hostname
# ---- root password
# passwd
# ---- account setup
# useradd -m fabri
# passwd fabri
# usermod -aG wheel,audio,video,storage fabri 
# visudo
# ##uncomment the line starting with %wheel
# --- bootloader
# pacman -S grub efibootmgr
# grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot <BOOT PARTITION>
# grub-mkconfig -o /boot/grub/grub.cfg
# ---- enable services
# systemctl enable dhcpcd
# systemctl enable NetworkManager
# systemctl enable iwd
# --- unmount disks
# umount /mnt/boot
# umount /mnt
# ---- reboot
# reboot now


# Download this script
# curl -O https://raw.githubusercontent.com/FabriDamazio/dotfiles/master/install.sh

# Make executable
# chmod +x install.sh
# ./.install.sh

##############################################################################
# VARIABLES                                                                  #
##############################################################################
yay_repo_url="https://aur.archlinux.org/yay.git"
dotfiles_repo_url="https://github.com/FabriDamazio/dotfiles.git"
temp_dir="temp"

# ollama configuration
install_ollama_model=false
ollama_model="qwen3-coder"

# Terminal colors
RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;93m'
NO_COLOR='\e[0m'

packages_pacman=(
    amd-ucode
    fastfetch
  	nano
		vim
		openssh
		htop
		wget
		iwd
		wireless_tools
		wpa_supplicant
		smartmontools
		xdg-utils
    hyprland
    xorg
		dunst
		kitty
		uwsm
		xdg-desktop-portal-hyprland
		qt5-wayland
		qt6-wayland
	  grim
		slurp
    libva-nvidia-driver  
    linux-firmware-nvidia
    nvidia-open-dkms
    nvidia-utils
    git
    base-devel
    gstreamer
    ncurses
    openssl
    libssh
    unixodbc
    webkit2gtk
    gst-plugins-base
    mesa
    libgl
    libxml2
    libnotify
    fop
    libxslt
    blueman
    bluez
    bluez-utils
    bluez-deprecated-tools
    firefox
    flameshot
    gnome-disk-utility
    godot
    gzip
    gtk3
    hypridle
    hyprlock
    hyprpaper
    hyprpicker
    hyprpolkitagent
    hyprland-qt-support
    inotify-tools
    mpv
    mpv-mpris
    nautilus
    nm-connection-editor
    noto-fonts
    nwg-look
    openrgb
    pam
    pavucontrol
    pipewire
    pipewire-audio
    pipewire-pulse
    playerctl
    ripgrep
    rofi
    sddm
    spotify-launcher
    starship
    stow
    swaync
    thunderbird
    ttf-jetbrains-mono-nerd
    waybar
    wireplumber
    xdg-desktop-portal-gtk
    zed
)

packages_yay=(
    catppuccin-gtk-theme-mocha
    neovim-git
    mpdris2-rs
    vial-appimage
)

mise_core_tools=(
    java@openjdk-21
    erlang@28.1
    elixir@1.19.0-otp-28
    dotnet
  )

##############################################################################
# PRE INSTALLATION                                                           #
##############################################################################

# Check internet connection 
echo -e "${NO_COLOR}[INFO] Checking internet connection...${NO_COLOR}"
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${RED}[ERROR] Unable to reach the internet.${NO_COLOR}"
  exit 1
else
  echo -e "${GREEN}[INFO] Internet connection verified.${NO_COLOR}"
fi
# Update pacman database
echo -e "${NO_COLOR}[INFO] Updating pacman database...${NO_COLOR}"
sudo pacman -Sy --noconfirm &> /dev/null
echo -e "${GREEN}[INFO] Pacman database updated.${NO_COLOR}"

##############################################################################
# INSTALL PACKAGES                                                           #
##############################################################################

# Installing pacman packages
echo -e "${NO_COLOR}[INFO] Installing pacman packages...${NO_COLOR}"
for package in "${packages_pacman[@]}"; do
    if pacman -Q "$package" &> /dev/null; then
        echo -e "${GREEN}[INFO] $package is already installed.${NO_COLOR}"
    else
        echo -e "${NO_COLOR}[INFO] Installing $package...${NO_COLOR}"
        if sudo pacman -S --needed --noconfirm "$package" &> /dev/null; then
            echo -e "${GREEN}[INFO] $package installed successfully.${NO_COLOR}"
        else
            echo -e "${RED}[ERROR] Installation failed for $package. Check package name and internet connection.${NO_COLOR}"
        fi
    fi
done

# Installing yay
echo -e "${NO_COLOR}[INFO] Installing yay...${NO_COLOR}"

if command -v yay &> /dev/null; then
    echo -e "${GREEN}[INFO] yay already installed.${NO_COLOR}"
else
    [[ ! -d "$temp_dir" ]] && mkdir -p "$temp_dir"
    sudo pacman -S --needed --noconfirm git base-devel &> /dev/null
    git clone "$yay_repo_url" "$temp_dir/yay" &> /dev/null
    cd "$temp_dir/yay" && makepkg -si --noconfirm &> /dev/null
    yay -Y --gendb 
    yay -Syu --devel --noconfirm 
    yay -Y --noremovemake --sudoloop --save 
    cd && rm -rf "$temp_dir/yay"
    echo -e "${GREEN}[INFO] yay installation completed.${NO_COLOR}"
fi

# Installing AUR packages with yay
if command -v yay &> /dev/null; then
    echo -e "${NO_COLOR}[INFO] Installing AUR packages...${NO_COLOR}"
    for package in "${packages_yay[@]}"; do
        if yay -Q "$package" &> /dev/null; then
            echo -e "${GREEN}[INFO] $package is already installed.${NO_COLOR}"
        else
            echo -e "${NO_COLOR}[INFO] Installing $package...${NO_COLOR}"
            if yay -S --needed --noconfirm "$package" &> /dev/null; then
                echo -e "${GREEN}[INFO] $package installed successfully.${NO_COLOR}"
            else
                echo -e "${RED}[ERROR] Installation failed for $package.${NO_COLOR}"
            fi
        fi
    done
else
    echo -e "${YELLOW}[WARNING] yay not found. Skipping AUR packages.${NO_COLOR}"
fi

# Installing mise
echo -e "${NO_COLOR}[INFO] Installing mise...${NO_COLOR}"
if curl -fsSL https://mise.run | sh; then
    echo -e "${GREEN}[INFO] Mise installation completed.${NO_COLOR}"
    if ! grep -q "mise" ~/.bashrc; then
      echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
      echo -e "${GREEN}[INFO] Mise added to bashrc.${NO_COLOR}"
    else
      echo "${YELLOW}[INFO] mise already configured in bashrc."
    fi

    # IMPORTANT: activate mise
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(~/.local/bin/mise activate bash)"
    echo -e "${GREEN}[INFO] Mise activated in current session.${NO_COLOR}"
else
    echo -e "${RED}[ERROR] Mise installation failed.${NO_COLOR}"
fi

# Install all core tools with mise
echo -e "${NO_COLOR}[INFO] Installing core tools via mise...${NO_COLOR}"

for tool in "${mise_core_tools[@]}"; do
    echo -e "${NO_COLOR}[INFO] Installing $tool...${NO_COLOR}"
    
    if mise install "$tool"; then
        echo -e "${GREEN}[INFO] $tool installed successfully.${NO_COLOR}"
        
        # Set as global default
        if mise use --global "$tool"; then
            echo -e "${GREEN}[INFO] $tool set as global default.${NO_COLOR}"
        else
            echo -e "${YELLOW}[WARNING] $tool installed but could not set as global default.${NO_COLOR}"
        fi
    else
        echo -e "${RED}[ERROR] Failed to install $tool.${NO_COLOR}"
    fi
done

echo -e "${GREEN}[INFO] $All core tools installed successfull.${NO_COLOR}"

# Installing Rust
echo -e "${NO_COLOR}[INFO] Installing Rust...${NO_COLOR}"
if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
  echo -e "${GREEN}[INFO] Rust installation completed.${NO_COLOR}"
else
  echo -e "${RED}[ERROR] Rust installation failed.${NO_COLOR}"
fi

# Configuring dotfiles
echo "${NO_COLOR}[INFO] Cloning dotfiles repository...${NO_COLOR}"
if git clone -q "$dotfiles_repo_url" && cd dotfiles; then
    for dir in */; do
        if [ -d "$dir" ]; then
            echo "${NO_COLOR}[INFO] Installing dotfiles from: ${dir%/}${NO_COLOR}"
            stow --adopt "${dir%/}" 
        fi
    done
    git reset --hard
    echo "${GREEN}[INFO] All dotfiles configured.${NO_COLOR}"
else
    echo "${RED}[ERROR] Failed to clone dotfiles.${NO_COLOR}" >&2
fi

# Applying GTK Theme
echo -e "${NO_COLOR}[INFO] Applying Catppuccin Mocha Sapphire theme...${NO_COLOR}"
if gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-sapphire-standard+default" && \
   gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'; then
  echo -e "${GREEN}[INFO] Theme applied successfully.${NO_COLOR}"
else
  echo -e "${RED}[ERROR] Failed to apply theme.${NO_COLOR}"
fi

# Enable Bluetooth service
echo -e "${NO_COLOR}[INFO] Enabling Bluetooth service...${NO_COLOR}"
if sudo systemctl enable bluetooth; then
    echo -e "${GREEN}[INFO] Bluetooth service enabled successfully.${NO_COLOR}"
else
    echo -e "${RED}[ERROR] Bluetooth service enable failed.${NO_COLOR}"
fi

# Enable Waybar service
echo -e "${NO_COLOR}[INFO] Enabling Waybar service...${NO_COLOR}"
if systemctl --user enable waybar; then
  echo -e "${GREEN}[INFO] Waybar service enabled successfully.${NO_COLOR}"
else
  echo -e "${RED}[ERROR] Waybar service enable failed.${NO_COLOR}"
fi

# Enable pipewire-pulse service
echo -e "${NO_COLOR}[INFO] Enabling pipewire-pulse service...${NO_COLOR}"
if systemctl --user enable pipewire-pulse; then
  echo -e "${GREEN}[INFO] pipewire-pulse service enabled successfully.${NO_COLOR}"
else
  echo -e "${RED}[ERROR] pipewire-pulse service enable failed.${NO_COLOR}"
fi

# Installing Ollama
echo -e "${NO_COLOR}[INFO] Installing Ollama...${NO_COLOR}"
if curl -fsSL https://ollama.ai/install.sh | sh; then
  echo -e "${GREEN}[INFO] Ollama installation completed.${NO_COLOR}"
else
  echo -e "${RED}[ERROR] Ollama installation failed.${NO_COLOR}"
fi

# Install Fly.io
echo -e "${NO_COLOR}[INFO] Installing Fly.io...${NO_COLOR}"
if curl -fsSL https://fly.io/install.sh | sh; then
    echo -e "${GREEN}[INFO] Fly.io installation completed.${NO_COLOR}"
else
    echo -e "${RED}[ERROR] Fly.io installation failed.${NO_COLOR}"
fi

# Pull Ollama model with user prompt
echo -e "${YELLOW}[QUESTION] Do you want to pull the Ollama model: $ollama_model? (y/N)${NO_COLOR}"
read -r response

# Convert response to lowercase and check - assume N for anything other than y/yes/sim/s
if [[ "${response,,}" =~ ^(yes|y|sim|s)$ ]]; then
    echo -e "${NO_COLOR}[INFO] Pulling Ollama model: $ollama_model...${NO_COLOR}"
    if ollama pull "$ollama_model"; then
        echo -e "${GREEN}[INFO] Ollama model '$ollama_model' downloaded successfully.${NO_COLOR}"
    else
        echo -e "${RED}[ERROR] Ollama model '$ollama_model' download failed.${NO_COLOR}"
    fi
else
    echo -e "${YELLOW}[INFO] Ollama model installation skipped.${NO_COLOR}"
fi

# Enable SDDM service
echo -e "${NO_COLOR}[INFO] Enabling Bluetooth service...${NO_COLOR}"
if sudo systemctl enable sddm; then
    echo -e "${GREEN}[INFO] Bluetooth service enabled successfully.${NO_COLOR}"
else
    echo -e "${RED}[ERROR] Bluetooth service enable failed.${NO_COLOR}"
fi

# init sound on startup
# customiza sddm
#expert lsp
#remove boot menu
# configure git

# steam 
# needs enable multilib on pacman
# install pacman lib32-nvidia-utils (needs multilib)
# /etc/pacman.conf
#[multilib]
#Include = /etc/pacman.d/mirrorlist
