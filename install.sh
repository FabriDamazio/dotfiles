# Installation script

##############################################################################
# ARCH LINUX INSTALLATION                                                    #
##############################################################################
# ---- 1. setting keymaps:
# loadkeys br-abnt
# ---- 2. list the disks:
# fdisk -l
# ---- 3. creating partitions:
# fdisk <YOUR_BLOCK_DEVICE>
# n (to create new partition)
# t (to change partition type)
# ---- 4. create 3 partitions:
# 1 - 1Gb size - EF (uefi) - for boot
# 2 - 180gb - 83 (linux Ext4) - for root
# 3 - the rest - 83 (linux Ext4) - for home
# ---- 5. formating disks
# mkfs.fat -F32 <BOOT PARTITION> (e.g /dev/sda1)
# mkfs.ext4 <ROOT PARTITION>
# mkfs.ext4 <HOME PARTITION>
# ---- 6. mouting partitions
# mount <ROOT PARTITION> /mnt
# mount --mkdir <BOOT PARTITION> /mnt/boot
# mount --mkdir <HOME PARTITION> /mnt/home
# ---- 7. internet connection (just for WIFI, ethernet skip it)
# iwctl
# station list # this will show youre wireless cards usually it will be wlan0
# station wlan0 get-networks
# station wlan0 connect YOUR_WIFI_NETWORK
# enter the password when prompted
# you should be connected soon
# press CTRL C to leave
# ---- 8. install the base system
# pacman -Syy
# pacstrap -K /mnt base linux linux-firmware linux-headers
# ---- 9. arch linux installed. enter the new system
# arch-chroot /mnt
# ---- 10. generate the swapfile
# mkswap -U clear --size 16G --file /swapfile
# swapon /swapfile
# ---- 11. exit the system
# exit
# ---- 12. generate the FSTAB file
# genfstab -U /mnt >> /mnt/etc/fstab
# ---- 13. back to system
# arch-chroot /mnt
# ---- 14. installing pacman packages
# pacman -S sudo vi iwd dhcpcd networkmanager 
# ---- 15. setting timezone
# timedatectl set-timezone America/Sao_Paulo
# ---- 16. setting clock
# hwclock --systohc
# timedatectl set-ntp true
# ---- 17. locales (uncomment us,pt_BR, ja_JP and  ZN_ch)
# vi /etc/locale.gen
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# ---- 18. setting hostname
# echo archlinux > /etc/hostname
# ---- 19. root password
# passwd
# ---- 20. account setup
# useradd -m fabri
# passwd fabri
# usermod -aG wheel,audio,video,storage fabri 
# visudo
# ##uncomment the line starting with %wheel
# --- 21. bootloader
# pacman -S grub efibootmgr
# grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot <BOOT PARTITION>
# grub-mkconfig -o /boot/grub/grub.cfg
# ---- 22. enable basic services on startup
# systemctl enable dhcpcd
# systemctl enable NetworkManager
# systemctl enable iwd
# --- 23. exit and unmount disks
# exit
# umount /mnt/boot
# umount /mnt
# ---- 24. reboot
# reboot now


# 25. Download this script
# curl -O https://raw.githubusercontent.com/FabriDamazio/dotfiles/master/install.sh

# 26. Make executable and run
# chmod +x install.sh
# ./.install.sh

##############################################################################
# VARIABLES                                                                  #
##############################################################################
YAY_REPO_URL="https://aur.archlinux.org/yay.git"
DOTFILES_REPO_URL="https://github.com/FabriDamazio/dotfiles.git"
TEMP_DIR="temp"
USER="fabri"
SDDM_THEMES_URL="https://raw.githubusercontent.com/FabriDamazio/sddm-fabri-themes/master/setup.sh"
LOG_FILE="$HOME/installation.log"
GIT_USERNAME="fabridamazio"
GIT_EMAIL="fabridamazio@gmail.com"

# ollama configuration
INSTALL_OLLAMA_MODEL=false
OLLAMA_MODEL="qwen3-coder"

# Terminal colors
RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;93m'
NO_COLOR='\e[0m'

PACKAGES_PACMAN=(
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
    loupe
    fop
    libxslt
    bash-completion
    blueman
    bluez
    bluez-utils
    bluez-deprecated-tools
    docker
    firefox
    flameshot
    glow
    gnome-disk-utility
    gnome-boxes
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
    noto-fonts-cjk
    noto-fonts-emoji
    nwg-look
    openrgb
    obsidian
    pam
    pavucontrol
    pipewire
    pipewire-audio
    pipewire-pulse
    playerctl
    postgresql
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
    wxwidgets-gtk3
    wxwidgets-common
    zed
)

PACKAGES_YAY=(
    catppuccin-gtk-theme-mocha
    neovim-git
    mpdris2-rs
    vial-appimage
)

MISE_TOOLS=(
    java@openjdk-21
    erlang@28.1
    elixir@1.19.1-otp-28
    dotnet
    usage
  )

# log messages function
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_entry="[$timestamp] [$level] $message"
  
    # write to file
    echo "$log_entry" >> "$LOG_FILE"
   
    # print on terminal
    case $level in
        "SUCCESS") echo -e "${GREEN}$log_entry${NO_COLOR}" ;;
        "ERROR") echo -e "${RED}$log_entry${NO_COLOR}" ;;
        "WARNING") echo -e "${YELLOW}$log_entry${NO_COLOR}" ;;
        "INFO") echo -e "${NO_COLOR}$log_entry${NO_COLOR}" ;;
        *) echo "$log_entry" ;;
    esac
}

##############################################################################
# PRE INSTALLATION                                                           #
##############################################################################

# Create the log file
if sudo touch "$LOG_FILE" && sudo chown $USER:$USER "$LOG_FILE"; then
    log_message "SUCCESS" "Log file setup completed"
    
    if echo "$(date): Test log entry" >> "$LOG_FILE"; then
        log_message "SUCCESS" "Log file is writable"
        log_message "INFO" "Log file location: $LOG_FILE"
    else
        log_message "ERROR" "Cannot wrute to log file"
    fi
else
    log_message "ERROR" "Log file setup failed"
fi

# Check internet connection 
log_message "INFO" "Checking internet connection..."
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  log_message "ERROR" "Unable to reach the internet"
  exit 1
else
  log_message "SUCCESS" "Internet connection verified"
fi
# Update pacman database
log_message "INFO" "Updating pacman database"
sudo pacman -Sy --noconfirm &> /dev/null
log_message "SUCCESS" "Pacman database updated"

##############################################################################
# INSTALL PACKAGES AND CONFIGURING                                           #
##############################################################################

# Installing pacman packages
log_message "INFO" "Installing pacman packages"
for package in "${PACKAGES_PACMAN[@]}"; do
    if pacman -Q "$package" &> /dev/null; then
        log_message "INFO" "$package is already installed"
    else
        log_message "INFO" "Installing $package..."
        if sudo pacman -S --needed --noconfirm "$package" &> /dev/null; then
            log_message "SUCCESS" "$package installed successfully"
        else
            log_message "ERROR" "Installation failed for $package. Check package name and internet connection"
        fi
    fi
done

# Installing yay
log_message "INFO" "Installation yay..."

if command -v yay &> /dev/null; then
    log_message "SUCCESS" "yay already installed"
else
    [[ ! -d "$TEMP_DIR" ]] && mkdir -p "$TEMP_DIR"
    sudo pacman -S --needed --noconfirm git base-devel &> /dev/null
    git clone "$YAY_REPO_URL" "$TEMP_DIR/yay" &> /dev/null
    cd "$TEMP_DIR/yay" && makepkg -si --noconfirm &> /dev/null
    yay -Y --gendb 
    yay -Syu --devel --noconfirm 
    yay -Y --noremovemake --sudoloop --save 
    cd && rm -rf "$TEMP_DIR/yay"
    log_message "SUCCESS" "yay installation completed"
fi

# Installing AUR packages with yay
if command -v yay &> /dev/null; then
    log_message "INFO" "Installation AUR packages..."
    for package in "${PACKAGES_YAY[@]}"; do
        if yay -Q "$package" &> /dev/null; then
            log_message "SUCCESS" "$package is already installed"
        else
            log_message "INFO" "Installing $package..."
            if yay -S --needed --noconfirm "$package" &> /dev/null; then
                log_message "SUCCESS" "$package installed successfully"
            else
                log_message "ERROR" "Installation failed for $package"
            fi
        fi
    done
else
    log_message "WARNING" "yay not found. Skipping AUR packages"
fi

# Installing mise
log_message "INFO" "Installing mise..."
if curl -fsSL https://mise.run | sh; then
    log_message "SUCCESS" "Mise installation completed"
    if ! grep -q "mise" ~/.bashrc; then
      echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
      log_message "SUCCESS" "Mise added to bashrc"
    else
      log_message "SUCCESS" "Mise already configured in bashrc"
    fi

    # activate mise
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(~/.local/bin/mise activate bash)"
    log_message "SUCCESS" "Mise activated in current session"
else
    log_message "ERROR" "Mise installation failed"
fi

# Install all core tools with mise
log_message "INFO" "Installing mise tools"

for tool in "${MISE_TOOLS[@]}"; do
    log_message "INFO" "Installing $tool"
    
    if mise install "$tool"; then
        log_message "SUCCESS" "$tool installed successfully"
        
        # Set as global default
        if mise use --global "$tool"; then
            log_message "SUCCESS" "$tool set as global default"
        else
            log_message "WARNING" "$tool installed but could not set as global default"
        fi
    else
        log_message "ERROR" "Failed to install $tool"
    fi
done

# Installing Phoenix Framework
log_message "INFO" "Installing Phoenix Framework"
if command -v elixir >/dev/null 2>&1; then
    if mix archive.install hex phx_new --force; then
        log_message "SUCCESS" "Phoenix Framework installation completed"
    else
        log_message "ERROR" "Phoenix Framework installation failed"
    fi
else
    log_message "ERROR" "Elixir not found. Please install Elixir first"
fi

# Installing Rust
log_message "INFO" "Installing Rust"
if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
  log_message "SUCCESS" "Rust installation completed"
else
  log_message "ERROR" "Rust installation failed"
fi

# Configuring dotfiles
log_message "INFO" "Cloning dotfiles repository..."
if git clone -q "$DOTFILES_REPO_URL" && cd dotfiles; then
    for dir in */; do
        if [ -d "$dir" ]; then
            log_message "INFO" "Installing dotfiles from: ${dir%/}"
            stow --adopt "${dir%/}" 
        fi
    done
    git reset --hard
    log_message "SUCCESS" "All dotfiles configured"
else
    log_message "ERROR" "Failed to clone dotfiles"
fi

# Applying GTK Theme
log_message "INFO" "Applying Catppuccin Mocha Sapphire theme..."
if gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-sapphire-standard+default" && \
   gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'; then
  log_message "SUCCESS" "Theme applied successfully"
else
  log_message "ERROR" "Failed to apply theme"
fi

# Enable Bluetooth service
log_message "INFO" "Enabling Bluetooth service..."
if sudo systemctl enable bluetooth; then
    log_message "SUCCESS" "Bluetooth service enabled successfully"
else
    log_message "ERROR" "Bluetooth service enable failed"
fi

# Enable Waybar service
log_message "INFO" "Enabling Waybar service..."
if systemctl --user enable waybar; then
  log_message "SUCCESS" "Waybar service enabled successfully"
else
  log_message "ERROR" "Waybar service enable failed"
fi

# Enable pipewire-pulse service
log_message "INFO" "Enabling pipewire-pulse service..."
if systemctl --user enable pipewire-pulse; then
  log_message "SUCCESS" "pipewire-pulse service enabled successfully"
else
  log_message "ERROR" "pipewire-pulse service enable failed"
fi

# PostgreSQL - create the cluster and enable the service
log_message "INFO" "Setting up PostgreSQL..."
sudo -u postgres bash -c 'initdb -D /var/lib/postgres/data' && 
systemctl enable postgresql &&
log_message "SUCCESS" "PostgreSQL setup completed" || {
    log_message "ERROR" "PostgreSQL setup failed"
}

# Installing Ollama
log_message "INFO" "Installing Ollama..."
if curl -fsSL https://ollama.ai/install.sh | sh; then
  log_message "SUCCESS" "Ollama installation completed"
else
  log_message "ERROR" "Ollama installation failed"
fi

# Install Fly.io
log_message "INFO" "Installing Fly.io..."
if curl -fsSL https://fly.io/install.sh | sh; then
    log_message "SUCCESS" "Fly.io installation completed"
else
    log_message "ERROR" "Fly.io installation failed"
fi

# Configuring SDDM theme
log_message "INFO" "Configuring SDDM theme"
if curl -fsSL $SDDM_THEMES_URL | sh; then
    log_message "SUCCESS" "SDDM theme installed successfully"
else
    log_message "ERROR" "Failed to configure SDDM theme"
fi

# Pull Ollama model with user prompt
echo -e "${YELLOW}[QUESTION] Do you want to pull the Ollama model: $OLLAMA_MODEL? (y/N)${NO_COLOR}"
read -r response

# Convert response to lowercase and check - assume N for anything other than y/yes/sim/s
if [[ "${response,,}" =~ ^(yes|y|sim|s)$ ]]; then
    log_message "INFO" "Pulling Ollama model: $OLLAMA_MODEL..."
    if ollama pull "$OLLAMA_MODEL"; then
        log_message "SUCCESS" "Ollama model $OLLAMA_MODEL downloaded successfully"
    else
        log_message "ERROR" "Ollama model $OLLAMA_MODEL download failed"
    fi
else
    log_message "WARNING" "Ollama model installation skipped"
fi

# Enable SDDM service
log_message "INFO" "Enabling Bluetooth service..."
if sudo systemctl enable sddm; then
    log_message "SUCCESS" "Bluetooth service enabled successfully"
else
    log_messaged "ERROR" "Bluetooth service enable failed"
fi

# Enable multilib repository
log_message "INFO" "Enabling multilib repository..."
if sudo sed -i '/^#\[multilib\]/s/^#//; /^#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' /etc/pacman.conf; then
    log_message "SUCCESS" "Multilib repository enabled successfully"
    
    # Update package database
    log_message "INFO" "Updating package database..."
    if sudo pacman -Sy; then
        log_message "SUCCESS" "Package database updated with multilib"
    else
        log_message "ERROR" "Failed to update package database"
    fi
else
    log_message "ERROR" "Failed to enable multilib repository"
fi

# Install Steam with NVIDIA support
log_message "INFO" "Installing Steam with NVIDIA support..."
if sudo pacman -S --noconfirm steam steam-native-runtime; then
    log_message "SUCCESS" "Steam installed successfully"
    
    # Install NVIDIA gaming dependencies
    log_message "INFO" "Installing NVIDIA gaming dependencies"
    if sudo pacman -S --noconfirm \
        lib32-nvidia-utils \
        nvidia-utils \
        lib32-vulkan-icd-loader \
        vulkan-icd-loader; then
        
        log_message "SUCCESS" "NVIDIA gaming dependencies installed successfully"
    else
        log_message "WARNING" "Some NVIDIA dependencies failed to install"
    fi
else
    log_message "ERROR" "Steam installation failed"
fi

# Remove GRUB boot menu
if command -v grub-mkconfig &> /dev/null; then
  log_message "INFO" "Configuring GRUB for automatic boot without menu..."
  
  # Backup grub file
  if sudo cp /etc/default/grub /etc/default/grub.backup; then
      log_message "SUCCESS" "GRUB backup created successfully"
  else
      log_message "ERROR" "GRUB backup failed"
  fi
  
  # Apply configurations
  log_message "INFO" "Applying configurations..."
  if sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub && \
     sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub && \
     echo "GRUB_HIDDEN_TIMEOUT=0" | sudo tee -a /etc/default/grub > /dev/null; then
      log_message "SUCCESS" "Configurations applied successfully"
  else
      log_message "ERROR" "Failed to apply configurations"
  fi
  
  # Generate new GRUB configuration
  log_message "INFO" "Generating new GRUB configuration..."
  if sudo grub-mkconfig -o /boot/grub/grub.cfg; then
      log_message "SUCCESS" "GRUB boot menu removed successfully"
  else
      log_message "ERROR" "Failed to generate GRUB configuration"
  fi
fi

# # Configure Git user information
log_message "INFO" "Checking Git installation and configuring user..."

# Check if Git is installed and configure
if command -v git &> /dev/null; then
    log_message "INFO" "Git is installed. Configuring user information..."
    
    if git config --global user.name $GIT_USERNAME && \
       git config --global user.email $GIT_EMAIL; then
        log_message "SUCCESS" "Git configured successfully"
    else
        log_message "ERROR" "Failed to configure Git"
    fi
else
    log_message "WARNING" "Git is not installed. Skipping configuration"
fi

# Configure Docker
if command -v docker &> /dev/null; then
  log_message "INFO" "Configuring docker service and permissions..."

  if sudo systemctl enable docker; then
    log_message "SUCCESS" "Docker service enabled successfully"
  else
    log_message "ERROR" "Failed to enable Docker service"
  fi


  if sudo usermod -aG docker $USER; then
    log_message "SUCCESS" "User $USER added to docker group"
  else
    log_message "ERROR" "Failed to add $USER to docker group"
  fi
else
  log_message "WARNING" "Docker not installed. Skipping configuration"
fi

# Configure Early KMS for NVIDIA
log_message "INFO" "Configuring mkinitcpio for Early KMS for Nvidia"
if sudo sed -i '/^MODULES=/s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf; then
    log_message "SUCCESS" "NVIDIA modules added to mkinitcpio"
    
    # Rebuild initramfs
    log_message "INFO" "Rebuilding initramfs..."
    if sudo mkinitcpio -P; then
        log_message "SUCCESS" "Initramfs rebuilt with NVIDIA Early KMS"
    else
        log_message "ERROR" "Failed to rebuild initramfs"
    fi
else
    log_message "ERROR" "Failed to modify mkinitcpio.conf"
fi

log_message "SUCCESS" "Intallation completed successfully!"
log_message "SUCCESS" "Reboot you system to apply all changes"
