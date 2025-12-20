# 🍙 Airi's Gentoo Dotfiles

![Gentoo Linux](https://img.shields.io/badge/Gentoo-OpenRC-54487A?style=for-the-badge&logo=gentoo)
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-blue?style=for-the-badge&logo=wayland)
![Theme](https://img.shields.io/badge/Theme-Catppuccin_Mocha-pink?style=for-the-badge)

My personal configuration for a minimal, high-performance Gentoo Linux system.

## 🖼️ Overview

- **OS:** Gentoo Linux
- **Init System:** OpenRC
- **WM:** Hyprland
- **Shell:** Fish (with Starship)
- **Terminal:** Foot / Wezterm
- **Bar/Shell:** Quickshell
- **Idle Daemon:** Hypridle
- **Blue Light:** Hyprsunset
- **Editor:** Neovim (via build) / Nano
- **Launcher:** Fuzzel
- **File Manager:** Yazi (Terminal) + Thunar (GUI)
- **Audio:** PipeWire + MPD + RMPC
- **Input Method:** Fcitx5 (Japanese/Korean)
- **Browser:** Zen Browser (Binary)

---

## 📦 Installation Guide

### 1. Prerequisites

These dotfiles assume you have a working base Gentoo installation (Stage 3 + Bootloader).

- **User:** `airi` (Adjust commands if different)
- **Privileges:** `sudo` configured
- **Portage:** Synced and ready (`emerge --sync`)

### 2. Install Packages

I have provided a `packages.txt` file containing all system atoms and a script to install them.

1.  Make the script executable:
    ```bash
    chmod +x install.sh
    ```

2.  Run the installer:
    ```bash
    sudo ./install.sh
    ```

    *Note: This script uses `emerge --keep-going`, so if a specific package fails to build, it will attempt to finish the rest of the queue.*

---

## 🚀 How to Apply Dotfiles

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

* **Note:** If `checkout` fails because of existing files (like default `.bashrc`), delete or back up those specific files and run `c checkout` again.

### Step 2: Configure Git

Hide untracked files so `c status` isn't messy.

```bash
c config --local status.showUntrackedFiles no

```

---

## 🛠️ Post-Install Configuration

### 1. Enable Services (OpenRC)

Since we are using OpenRC, add the necessary daemons to the default runlevel.

```bash
# System Services
sudo rc-update add dbus default
sudo rc-update add cronie default
sudo rc-update add bluetooth default
sudo rc-update add NetworkManager default

# Audio (Pipewire)
# Gentoo usually handles Pipewire via XDG Autostart or Gentoo-pipewire-launcher
# Ensure you run 'gentoo-pipewire-launcher' in your Hyprland config.

```

### 2. Hyprland Autostart

The following tools are launched directly via `~/.config/hypr/hyprland.conf`:

* `quickshell` (Bar & Widgets)
* `hypridle` (Idle Daemon)
* `hyprsunset` (Blue Light Filter)
* `fcitx5` (Input Method)
* `mako` (Notifications)

### 3. Final Checks

* **Fish Shell:** Set as default: `chsh -s /bin/fish`
* **Quickshell:** Ensure the socket is active (happens automatically on first run).
* **MPD:** Create playlists dir: `mkdir -p ~/.local/state/mpd/playlists`
