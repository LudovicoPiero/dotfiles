{ pkgs, inputs, ... }:
{
  vars = {
    colorScheme = "catppuccin-mocha";
    email = "contact@yourmom.xd";
    isALaptop = false;
    opacity = 1.0;
    sshPublicKey = "";
    stateVersion = "24.11";
    terminal = "wezterm";
    timezone = "Asia/Tokyo";
    username = "me";
    withGui = true;
  };

  mine = {
    cliphist = {
      enable = true;
      allowImages = true;
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
      hasIPv6Internet = true;
    };

    emacs = {
      enable=true;
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
                "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
                "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/hide-avatar-decoration.css"
                "https://raw.githubusercontent.com/LudovicoPiero/discord-css/refs/heads/main/hide-invite-button.css"
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
              self = true;
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

    mpd = {
      enable = true;
    };

    ncmpcpp = {
      enable = true;
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
          package = inputs.ludovico-pkgs.packages.${pkgs.stdenv.hostPlatform.system}.whitesur-gtk-theme;
        };
      };
    };

    tlp = {
      enable = true;
    };

    vesktop = {
      enable = true;
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

    zen-browser = {
      enable = true;
    };
  };
}
