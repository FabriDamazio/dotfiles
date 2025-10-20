# My Awesome Dotfiles

> A carefully curated collection of configuration files for a beautiful, efficient, and modern Linux development environment powered by Hyprland.

## Table of Contents

- [Overview](#-overview)
- [Tools & Applications](#-tools--applications)
  - [Window Manager & Wayland](#-window-manager--wayland)
  - [Terminal & Shell](#-terminal--shell)
  - [Text Editors](#-text-editors)
  - [System Tools](#-system-tools)
  - [Application Launcher & UI](#-application-launcher--ui)
  - [Development Tools](#-development-tools)
  - [Multimedia](#-multimedia)
- [Installation](#-installation)
- [Screenshots](#-screenshots)
- [License](#-license)

---

## Overview

This repository contains my personal dotfiles for Arch Linux with a focus on a modern Wayland-based workflow using Hyprland as the compositor. The setup is optimized for development, productivity, and aesthetics.

---

## Screenshots

> Screenshots coming soon! 🎨

---

## Tools & Applications

### Window Manager & Wayland

- **[Hyprland](https://github.com/hyprwm/Hyprland)** - A dynamic tiling Wayland compositor that doesn't sacrifice on its looks. Beautiful animations and modern features.

- **[Waybar](https://github.com/Alexays/Waybar)** - Highly customizable Wayland bar for Sway and Wlroots based compositors. Provides system information, workspaces, and custom modules.

- **[Hyprpaper](https://github.com/hyprwm/hyprpaper)** - A blazing fast wallpaper utility for Hyprland with IPC controls.

- **[Hypridle](https://github.com/hyprwm/hypridle)** - Hyprland's idle daemon for managing screen timeout and sleep.

- **[Hyprlock](https://github.com/hyprwm/hyprlock)** - Hyprland's GPU-accelerated screen lock with beautiful blur effects.

- **[xdg-desktop-portal-hyprland](https://github.com/hyprwm/xdg-desktop-portal-hyprland)** - xdg-desktop-portal backend for Hyprland, enabling screen sharing and other desktop integration features.

### Terminal & Shell

- **[Kitty](https://github.com/kovidgoyal/kitty)** - The fast, feature-rich, cross-platform, GPU-based terminal emulator. Supports ligatures, tabs, splits, and extensive customization.

- **[Bash](https://www.gnu.org/software/bash/)** - The GNU Bourne Again shell. Configured with custom aliases and prompt.

- **[Starship](https://github.com/starship/starship)** - The minimal, blazing-fast, and infinitely customizable prompt for any shell. Written in Rust.

- **[Fastfetch](https://github.com/fastfetch-cli/fastfetch)** - A neofetch-like system information tool written in C. Extremely fast and highly customizable.

### Text Editors

- **[Neovim](https://github.com/neovim/neovim)** - Hyperextensible Vim-based text editor. The ultimate tool for efficient text editing and code development.

- **[Zed](https://github.com/zed-industries/zed)** - A high-performance, multiplayer code editor from the creators of Atom and Tree-sitter.

### System Tools

- **[SwayNC](https://github.com/ErikReider/SwayNotificationCenter)** - A simple notification daemon with a GTK GUI for notifications and the control center. Works perfectly with Hyprland.

- **[Rofi](https://github.com/davatorium/rofi)** - A window switcher, application launcher, and dmenu replacement. Highly customizable and scriptable.

- **[Flameshot](https://github.com/flameshot-org/flameshot)** - Powerful yet simple to use screenshot software with built-in annotation tools.

- **[Vial](https://get.vial.today/)** - An open-source cross-platform GUI and a QMK fork for configuring your keyboard in real-time.

### Application Launcher & UI

- **[Rofi](https://github.com/davatorium/rofi)** - A window switcher, application launcher and dmenu replacement with extensive theming capabilities.

### Development Tools

The dotfiles include configuration for various development tools installed via [mise](https://github.com/jdx/mise):

- **Java** (OpenJDK 21)
- **Erlang** (28.1)
- **Elixir** (1.19.0-otp-28)
- **.NET** (dotnet)
- **Rust** (via rustup)

### Multimedia

- **[Pipewire](https://gitlab.freedesktop.org/pipewire/pipewire)** - A server and user space API to deal with multimedia pipelines. Configured for audio routing and management.

---

## Installation

### Prerequisites

- Arch Linux (or Arch-based distribution)
- `git` installed
- Internet connection

### Quick Install

1. **Download the installation script:**
   ```bash
   curl -O https://raw.githubusercontent.com/FabriDamazio/dotfiles/master/install.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x install.sh
   ```

3. **Run the installation:**
   ```bash
   ./install.sh
   ```

The script will:
- Install all required packages via pacman
- Install AUR packages via yay
- Clone and configure dotfiles using GNU Stow
- Set up development tools via mise
- Configure themes and services
- Enable required systemd services

### Manual Installation

If you prefer to manually install specific configurations:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/FabriDamazio/dotfiles.git
   cd dotfiles
   ```

2. **Use GNU Stow to symlink configurations:**
   ```bash
   # Install specific tool configurations
   stow kitty
   stow nvim
   stow hyprland
   # ... or install all at once
   for dir in */; do stow "${dir%/}"; done
   ```

---

## License

This repository is available under the MIT License. Feel free to use and modify these configurations for your own setup.

