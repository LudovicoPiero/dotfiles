{ pkgs, inputs, ... }:
{
  vars = {
    colorScheme = "catppuccin-mocha";
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

  myOptions = {
    cliphist = {
      enable = true;
      allowImages = true;
      extraOptions = [
        "-max-dedupe-search"
        "10"
        "-max-items"
        "500"
      ];
      systemdTargets = [ "graphical-session.target" ];
    };

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
      silent = true;
    };

    dnscrypt2 = {
      enable = true;
      StateDirectory = "dnscrypt-proxy";
      hasIPv6Internet = false;
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

    fonts = {
      enable = true;
      size = 14;
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
        name = "SF Pro Rounded";
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.san-francisco-pro;
      };
      terminal = {
        name = "Iosevka Q";
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.iosevka-q;
      };
    };

    fuzzel = {
      enable = true;
    };

    gaming = {
      enable = true;
      withGamemode = true;
      withSteam = true;
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
      withLTO = true;
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

    moonlight = {
      enable = true;
      discordVariants = "canary";
      settings = {
        extensions = {
          moonbase = true;
          disableSentry = true;
          noTrack = true;
          noHideToken = true;
          betterCodeblocks = true;
          ownerCrown = true;
          betterTags = true;
          betterEmbedsYT = true;
          customSearchEngine = true;
          hideBlocked = true;
          imageViewer = true;
          mentionAvatars = true;
          noReplyPing = true;
          freeMoji = true;
          silenceTyping = true;
          nameColor = true;
          moonlight-css = {
            enabled = true;
            config = {
              paths = [
                # "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/fix-ui.css"
                # "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-catppuccin-mocha.theme.css"
              ];
            };
          };
          copyAvatarUrl = true;
          inviteToNowhere = true;
          nativeFixes = true;
          noMaskedLinkPaste = true;
          noNotificationSoundExceptDms = true;
          platformIcons = {
            enabled = true;
            config = {
              self = false;
            };
          };
          reverseImageSearch = true;
          selectivelyReduceMotion = {
            enabled = true;
            config = {
              avatarDecorations = true;
              profileEffects = true;
              nameplates = true;
              burstReactions = true;
              confetti = true;
            };
          };
        };
        repositories = [ "https://moonlight-mod.github.io/extensions-dist/repo.json" ];
      };
    };

    nvim = {
      enable = true;
    };

    pipewire = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };

    sddm = {
      enable = true;
    };

    secrets = {
      enable = true;
    };

    spotify = {
      enable = true;
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
          package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.whitesur-gtk-theme;
        };
      };
    };

    tlp = {
      enable = true;
    };

    vesktop = {
      enable = false;
      package = pkgs.vesktop.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            wrapProgram $out/bin/vesktop \
              --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer --enable-wayland-ime=true"
          '';
      });
      themeLinks = [
        # "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-catppuccin-mocha.theme.css"
        "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/fix-ui.css"
      ];
    };

    vscode = {
      enable = true;
    };

    waybar = {
      enable = true;
    };

    wezterm = {
      enable = true;
    };

    xdg-portal = {
      enable = true;
    };
  };
}
