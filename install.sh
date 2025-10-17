# Installation script

# Download this script
# wget https://raw.githubusercontent.com/FabriDamazio/dotfiles/master/install.sh

# Make executable
# chmod +x install.sh

##############################################################################
# VARIABLES                                                                  #
##############################################################################
yay_repo_url="https://aur.archlinux.org/yay.git"
dotfiles_repo_url="https://github.com/FabriDamazio/dotfiles.git"
temp_dir="temp"

# Terminal colors
RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;93m'
NO_COLOR='\e[0m'

packages_pacman=(
    git
    base-devel
    gstreamer
    ncurses
    openssl
    libssh
    unixodbc
    wxwidgets-gtk3
    webkit2gtk
    gst-plugins-base
    mesa
    libgl
    libxml2
    libnotify
    freeglut
    fop
    libxslt
    blueman
    firefox
    flameshot
    gnome-disk-utility
    godot
    grim
    gzip
    gtk3
    glu
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
    playerctl
    qt5-wayland
    qt6-wayland
    ripgrep
    rofi
    sddm
    spotify-launcher
    starship
    stow
    swaync
    thunderbird
    waybar
    wireplumber
    wxwidgets-common
    wxwidgets-gtk3
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
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
# Check if wget is installed
if ! command -v wget &> /dev/null; then
  echo -e "${RED}[ERROR] wget is not installed.${NO_COLOR}"
  echo -e "${NO_COLOR}[INFO] Installing wget...${NO_COLOR}"
  sudo pacman -S --noconfirm wget
else
  echo -e "${GREEN}[INFO] wget is already installed.${NO_COLOR}"
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
    stow . && echo "${GREEN}[SUCCESS] Dotfiles configured${NO_COLOR}"
else
    echo "${RED}[ERROR] Failed to clone dotfiles${NO_COLOR}" >&2
fi

#expert lsp
#flyctl
#remove boot menu
# cofigure git

# steam 
# needs enable multilib on pacman
# /etc/pacman.conf
#[multilib]
#Include = /etc/pacman.d/mirrorlist

# replace bashrc
