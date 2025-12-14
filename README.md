# 🍙 Airi's Arch Dotfiles

![Arch Linux](https://img.shields.io/badge/Arch_Linux-Systemd-blue?style=for-the-badge&logo=arch-linux)
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-blue?style=for-the-badge&logo=wayland)
![Theme](https://img.shields.io/badge/Theme-Catppuccin_Mocha-pink?style=for-the-badge)

My personal configuration for a minimal, high-performance Arch Linux system.

## 🖼️ Overview

- **OS:** Arch Linux
- **WM:** Hyprland
- **Shell:** Fish (with Starship)
- **Terminal:** Alacritty / Foot
- **Bar/Shell:** Quickshell (Qt6)
- **Idle Daemon:** Hypridle
- **Blue Light:** Hyprsunset
- **Editor:** Neovim
- **Launcher:** Fuzzel / FFF
- **File Manager:** Yazi (Terminal) + Thunar (GUI)
- **Audio:** PipeWire + MPD + RMPC
- **Input Method:** Fcitx5 (Japanese/Korean)
- **Browser:** Zen Browser / Firefox

---

## 📦 Installation Guide

### 1. Prerequisites

These dotfiles assume you have a working base Arch installation.

- **AUR Helper:** `yay` (Required for Quickshell & Hypr-tools)
- **User:** `airi` (Adjust commands if different)

### 2. Core Packages (The "One-Liner")

Install these packages to establish the base environment.

```bash
# 1. Update & Install Base
yay -Syu

# 2. Install World
yay -S --needed \
  # System Core & Kernel Tools
  linux linux-firmware base-devel git sudo \
  cpupower cronie man-db \
  \
  # Wayland & Hyprland Stack
  hyprland-git hypridle hyprlock hyprsunset \
  quickshell-git mako swaybg \
  xdg-desktop-portal-hyprland wl-clipboard \
  grim slurp libnotify \
  fuzzel cliphist \
  \
  # Audio & Music (MPD Stack)
  pipewire pipewire-pulse wireplumber \
  mpd mpdris2 rmpc-git \
  \
  # Shell & CLI Tools
  fish starship zoxide fzf \
  bat lsd ripgrep fd \
  jq tealdeer fastfetch \
  neovim github-cli \
  \
  # File Management
  yazi thunar thunar-archive-plugin thunar-volman tumbler gvfs \
  unzip p7zip unrar \
  \
  # Media & Viewers
  mpv yt-dlp streamlink \
  imv viewnior \
  \
  # Network
  curl rsync whois nmap \
  bind-tools qbittorrent \
  \
  # Input Method & Fonts
  fcitx5-im fcitx5-mozc-ut fcitx5-hangul fcitx5-gtk \
  noto-fonts noto-fonts-cjk ttf-font-awesome \
  ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
```

---

## 🚀 How to Apply Dotfiles (Fresh Install)

I use the **Git Bare Repository** method. This allows managing dotfiles without symlinks.

### Step 1: Clone the Repo

Ensure your `$HOME` is relatively clean to avoid conflicts.

```bash
# 1. Clone as a bare repository
git clone --bare git@github.com:LudovicoPiero/dotfiles.git $HOME/.cfg

# 2. Define the alias temporarily
alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# 3. Checkout the content
c checkout
```

- **Note:** If `checkout` fails because of existing files (like default `.bashrc`), delete or back up those specific files and run `c checkout` again.

### Step 2: Configure Git

Hide untracked files so `c status` isn't messy.

```bash
c config --local status.showUntrackedFiles no
```

---

## 🛠️ Post-Install Configuration

### 1\. Enable Services (Systemd)

Unlike OpenRC, we use `systemctl` to enable background daemons.

```bash
# Audio & Bluetooth
systemctl --user enable --now pipewire pipewire-pulse wireplumber
systemctl --user enable --now mpd
systemctl --user enable --now mpdris2

# System Maintenance
sudo systemctl enable --now cronie      # For cron jobs
sudo systemctl enable --now fstrim.timer # SSD maintenance
```

### 2\. Hyprland Autostart

The following tools are launched directly via `~/.config/hypr/hyprland.conf`:

- `quickshell` (Bar & Widgets)
- `hypridle` (Idle Daemon)
- `hyprsunset` (Blue Light Filter)
- `fcitx5` (Input Method)
- `mako` (Notifications)

### 3\. Final Checks

- **Fish Shell:** Set as default: `chsh -s /usr/bin/fish`
- **Quickshell:** Ensure the socket is active (happens automatically on first run).
- **MPD:** Create playlists dir: `mkdir -p ~/.local/state/mpd/playlists`
