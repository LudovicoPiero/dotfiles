# 🍙 Airi's Gentoo Dotfiles

![Gentoo](https://img.shields.io/badge/Gentoo-OpenRC-purple?style=for-the-badge&logo=gentoo)
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-blue?style=for-the-badge&logo=wayland)
![Theme](https://img.shields.io/badge/Theme-Catppuccin_Mocha-pink?style=for-the-badge)

My personal configuration for a minimal, high-performance Gentoo Linux system.

## 🖼️ Overview
* **OS:** Gentoo Linux (OpenRC)
* **WM:** Hyprland
* **Shell:** Fish (with Starship)
* **Terminal:** Alacritty / Foot (Configured via Home)
* **Bar:** Waybar
* **Editor:** Neovim
* **Launcher:** Fuzzel
* **File Manager:** Yazi (Terminal) + Thunar (GUI)
* **Audio:** PipeWire + MPD + RMPC
* **Input Method:** Fcitx5 (Japanese/Korean)
* **Browser:** Firefox / Brave (User preference)

---

## 📦 Installation Guide

### 1. Base System Requirements
These dotfiles assume you have a working minimal Gentoo installation with **OpenRC**.
* **Profile:** `default/linux/amd64/23.0/desktop` (or similar)
* **User:** `airi` (Adjust commands if different)

### 2. Core Packages (The "One-Liner")
Install these packages to establish the base environment.

```bash
# 1. Enable GURU overlay (Required for some Wayland/Media tools)
sudo emerge --ask app-eselect/eselect-repository
sudo eselect repository enable guru
sudo emaint sync -r guru

# 2. Install World
sudo emerge --ask \
  # System Core & Kernel Tools
  sys-kernel/gentoo-sources sys-kernel/linux-firmware sys-apps/pciutils \
  app-portage/gentoolkit app-portage/cpuid2cpuflags sys-process/cronie \
  app-admin/sudo sys-apps/earlyoom \
  \
  # Wayland & Hyprland Stack
  gui-wm/hyprland gui-apps/waybar gui-apps/mako gui-apps/swaybg \
  gui-apps/xdg-desktop-portal-hyprland gui-apps/wl-clipboard \
  gui-apps/grim gui-apps/slurp gui-apps/libnotify \
  gui-apps/fuzzel gui-apps/cliphist \
  \
  # Audio & Music (MPD Stack)
  media-video/pipewire media-video/wireplumber media-libs/libpulse \
  media-sound/mpd media-sound/mpdris2 media-sound/rmpc \
  \
  # Shell & CLI Tools
  app-shells/fish app-shells/starship app-shells/zoxide app-shells/fzf \
  sys-apps/bat sys-apps/lsd sys-apps/ripgrep sys-apps/fd \
  app-misc/jq app-misc/tealdeer app-misc/neofetch \
  app-editors/neovim dev-vcs/git dev-vcs/github-cli \
  \
  # File Management
  app-misc/yazi xfce-base/thunar xfce-extra/thunar-archive-plugin \
  xfce-extra/thunar-volman xfce-extra/tumbler gnome-base/gvfs \
  app-arch/unzip app-arch/p7zip app-arch/unrar \
  \
  # Media & Viewers
  media-video/mpv net-misc/yt-dlp net-misc/streamlink \
  media-gfx/imv media-gfx/viewnior \
  \
  # Network
  net-misc/curl net-misc/rsync net-misc/whois net-analyzer/nmap \
  net-dns/bind-tools net-p2p/qbittorrent \
  \
  # Input Method & Fonts
  app-i18n/fcitx5 app-i18n/fcitx5-configtool app-i18n/fcitx5-gtk \
  app-i18n/fcitx5-qt app-i18n/mozc app-i18n/fcitx-hangul \
  media-fonts/noto media-fonts/noto-cjk media-fonts/fontawesome \
  media-fonts/symbols-nerd-font
````

-----

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

  * **Note:** If `checkout` fails because of existing files (like default `.bashrc`), delete or back up those specific files and run `c checkout` again.

### Step 2: Configure Git

Hide untracked files so `c status` isn't messy.

```bash
c config --local status.showUntrackedFiles no
```

### Step 3: Symlink System Configs

Since Gentoo configs live in `/etc`, we need to link the versions stored in `~/.config/portage` back to the system.

```bash
# Backup original (just in case)
sudo mv /etc/portage /etc/portage.bak

# Create directory structure
sudo mkdir -p /etc/portage

# Symlink your tracked configs
sudo ln -s ~/.config/portage/make.conf /etc/portage/make.conf
sudo ln -s ~/.config/portage/package.use /etc/portage/package.use
sudo ln -s ~/.config/portage/package.accept_keywords /etc/portage/package.accept_keywords
sudo ln -s ~/.config/portage/package.mask /etc/portage/package.mask
sudo ln -s ~/.config/portage/repos.conf /etc/portage/repos.conf
sudo ln -s ~/.config/portage/savedconfig /etc/portage/savedconfig
```

-----

## 🛠️ Post-Install Configuration

### 1\. Enable Services (OpenRC)

```bash
# Display Manager (Login)
sudo rc-update add agetty.tty1 default

# Audio & Hardware
sudo rc-update add elogind boot
sudo rc-update add dbus default
sudo rc-update add earlyoom default
sudo rc-update add cronie default # For fstrim
```

### 2\. User Services (Hyprland Autostart)

These services start automatically when Hyprland launches (configured in `~/.config/hypr/hyprland.conf`):

  * `fcitx5` (Input Method)
  * `waybar` (Status Bar)
  * `mako` (Notifications)
  * `mpd` (Music Daemon)
  * `mpdris2` (Media Keys)

### 3\. Final Checks

  * **Fish Shell:** Set as default: `chsh -s /bin/fish`
  * **Fonts:** Refresh cache: `fc-cache -fv`
  * **MPD:** Create playlists dir: `mkdir -p ~/.local/state/mpd/playlists`
