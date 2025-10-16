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
    blueman
    firefox
    flameshot
    git
    gnome-disk-utility
    godot
    grim
    gzip
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

##############################################################################
# INSTALL PACKAGES                                                           #
##############################################################################

# yay
#pacman -S --needed git base-devel
#git clone https://aur.archlinux.org/yay.git
#cd yay
#makepkg -si

# Installing pacman packages
echo -e "${NO_COLOR}[INFO] Installing pacman packages...${NO_COLOR}"
for package in "${packages_pacman[@]}"; do
    if pacman -Q "$package" &> /dev/null; then
        echo -e "${GREEN}[INFO] $package is already installed.${NO_COLOR}"
    else
        echo -e "${YELLOW}[INFO] Installing $package...${NO_COLOR}"
        if sudo pacman -S --needed --noconfirm "$package" &> /dev/null; then
            echo -e "${GREEN}[INFO] $package installed successfully.${NO_COLOR}"
        else
            echo -e "${RED}[ERROR] Installation failed for $package. Check package name and internet connection.${NO_COLOR}"
        fi
    fi
done

echo -e "${NO_COLOR}[INFO] Installing yay...${NO_COLOR}"

if command -v yay &> /dev/null; then
    echo -e "${GREEN}[INFO] yay already installed.${NO_COLOR}"
else
    [[ ! -d "$temp_dir" ]] && mkdir -p "$temp_dir"
    sudo pacman -S --needed --noconfirm git base-devel &> /dev/null
    git clone "$yay_repo_url" "$temp_dir/yay" &> /dev/null
    cd "$temp_dir/yay" && makepkg -si --noconfirm &> /dev/null
    yay -Y --gendb &> /dev/null 
    yay -Syu --devel &> /dev/null
    yay -Y --nocleanafter --noremovemake --sudoloop --save &> /dev/null
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
            echo -e "${YELLOW}[INFO] Installing $package...${NO_COLOR}"
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

# mise
#erlang (e dependencias)
#elixir
#rust
#flyctl
#remove boot menu

# steam 
# needs enable multilib on pacman
# /etc/pacman.conf
#[multilib]
#Include = /etc/pacman.d/mirrorlist
