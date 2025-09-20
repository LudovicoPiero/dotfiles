{
  pkgs,
  inputs,
  config,
  ...
}:
{
  vars = {
    colorScheme = "catppuccin-macchiato";
    email = "lewdovico@gnuweeb.org";
    isALaptop = true;
    opacity = 1.0;
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtzB1oiuDptWi04PAEJVpSAcvD96AL0S21zHuMgmcE9 ludovico@sforza";
    stateVersion = "24.11";
    terminal = "wezterm";
    timezone = "Asia/Tokyo";
    username = "airi";
    withGui = true;
  };

  mine = {
    cliphist = {
      enable = true;
    };

    direnv = {
      enable = true;
    };

    dnscrypt2 = {
      enable = !config.mine.wireguard.enable;
      StateDirectory = "dnscrypt-proxy";
      hasIPv6Internet = false;
    };

    emacs = {
      enable = true;
    };

    fcitx5 = {
      enable = true;
    };

    firefox = {
      enable = true;
    };

    fish = {
      enable = true;
    };

    foot = {
      enable = true;
    };

    fonts = {
      enable = true;
      size = 15;
      cjk = {
        name = "Noto Sans CJK";
        package = pkgs.noto-fonts-cjk-sans;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      icon = {
        name = "Symbols Nerd Font Mono";
        package = pkgs.nerd-fonts.symbols-only;
      };
      main = {
        name = "SF Pro Display";
        package = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.san-francisco-pro;
      };
      terminal = {
        name = "Iosevka Q";
        package = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.iosevka-q;
      };
    };

    fuzzel = {
      enable = true;
    };

    gammastep = {
      enable = true;
    };

    gaming = {
      enable = true;
      withGamemode = true;
      withSteam = true;
    };

    ghostty = {
      enable = false;
    };

    git = {
      enable = true;
    };

    gpg = {
      enable = true;
    };

    hypridle = {
      enable = true;
    };

    hyprland = {
      enable = true;
    };

    hyprlock = {
      enable = true;
    };

    keyring = {
      enable = true;
    };

    mako = {
      enable = true;
    };

    mpd = {
      enable = true;
    };

    ncmpcpp = {
      enable = false;
    };

    nvim = {
      enable = true;
    };

    pipewire = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };

    rmpc = {
      enable = true;
    };

    sddm = {
      enable = true;
    };

    secrets = {
      enable = true;
    };

    sway = {
      enable = false;
    };

    theme = {
      enable = true;
      gtk = {
        cursorTheme = {
          name = "phinger-cursors-light";
          size = 24;
          package = pkgs.phinger-cursors;
        };
        iconTheme = {
          name = "WhiteSur-dark";
          package = pkgs.whitesur-icon-theme;
        };
        theme = {
          name = "WhiteSur-Dark";
          package = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.whitesur-gtk-theme;
        };
      };
    };

    tlp = {
      enable = true;
    };

    tmux = {
      enable = true;
    };

    vesktop = {
      enable = true;
      themeLinks = [
        # "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/hide-avatar-decoration.css"
        # "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/hide-invite-button.css"
        # "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/hide-clantag.css"
        # "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/fix-ui.css"
        "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
        # "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-catppuccin-mocha.theme.css"
      ];
    };

    waybar = {
      enable = true;
    };

    wezterm = {
      enable = true;
    };

    wireguard = {
      enable = true;
    };

    wleave = {
      enable = true;
    };

    xdg-portal = {
      enable = true;
    };

    zen-browser = {
      enable = true;
    };

    zsh = {
      enable = false;
    };
  };
}
