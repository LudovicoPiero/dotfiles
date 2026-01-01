# NixOS // Niri Configuration

A declarative, modular, and _performance-oriented_ NixOS configuration featuring the **Niri** Wayland compositor and the **Tokyo Night** color scheme.

![Screenshot](assets/ss.png)

## 🍙 Overview

- **OS:** NixOS
- **Compositor:** [Niri](https://github.com/YaLTeR/niri) (Scrollable Tiling)
- **Shell:** Fish (w/ Hydro prompt)
- **Terminal:** Alacritty
- **Launcher:** Rofi
- **Bar:** Waybar
- **Notifications:** Mako
- **Editor:** Neovim

## ✨ Features

- **Modular Architecture:** Configuration split into focused modules (Git, Fish, GPG, TLP, etc.) for easy maintenance.
- **Centralized Variables:** Global control over user details, fonts, and system settings via `vars.nix`.
- **Custom File Manager:** Uses `hj` (hjem) to manage dotfiles declaratively without relying on Home Manager.
- **Workflow Enhancements:**
  - Custom Fish functions (`fe`, `fef`, `yt`, `watchLive`).
  - Unified Tokyo Night theming across GTK, Rofi, and Waybar.

## 🎨 Credits

- **Theme:** [Tokyo Night](https://github.com/folke/tokyonight.nvim)
- **Icons:** Papirus Dark
- **Cursor:** Phinger Cursors
- **Font:** Inter & Iosevka
