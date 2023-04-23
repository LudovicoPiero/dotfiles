{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: {
  imports = [
    ../shared/home.nix
  ];

  colorscheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font.name = "Noto Sans"; #TODO: change it to Google Sans later

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        size = "compact";
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "capitaine-cursors-white";
      size = 24;
      package = pkgs.capitaine-cursors;
    };

    gtk2.extraConfig = "gtk-cursor-theme-size=24";
    gtk3.extraConfig."gtk-cursor-theme-size" = 24;
    gtk4.extraConfig."gtk-cursor-theme-size" = 24;
  };

  home = {
    packages = lib.attrValues {
      #TODO: separate firefox
      inherit
        (pkgs)
        fuzzel
        bemenu
        discord-canary
        firefox
        neofetch
        ripgrep
        mpv
        nitch
        ;

      inherit
        (inputs.nixpkgs-wayland.packages.${system})
        grim
        slurp
        swaybg
        swayidle
        swaylock
        wf-recorder
        wl-clipboard
        wlogout
        ;
    };

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      XCURSOR_SIZE = "24";
    };
  };

  programs = {
    wezterm = {
      enable = true;
      extraConfig = import ./config/wezterm.nix {
        inherit (config) colorscheme;
      };
    };

    #doom-emacs = {
    #  enable = true;
    #  doomPrivateDir = ./config/emacs;
    #  emacsPackage = pkgs.emacsPgtk;
    #};

    firefox = {
      enable = true;

      #TODO
      # extensions = lib.

      profiles."ludovico".isDefault = true;
    };

    waybar = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
      settings = {
        mainBar = {
          position = "bottom";
          monitor = "eDP-1";
          height = 25;

          modules-left = [
            "wlr/workspaces"
            "tray"
          ];
          modules-right = [
            "network"
            "pulseaudio"
            "battery"
            "custom/date"
            "clock"
          ];
          "pulseaudio" = {
            "format" = "{icon} {volume}%";
            "format-muted" = "󰝟";
            "on-click" = "amixer -q set Master toggle-mute";
            "format-icons" = ["" "" ""];
          };
          "cpu" = {
            "interval" = 10;
            "format" = " {}%";
            "max-length" = 10;
          };
          "memory" = {
            "interval" = 30;
            "format" = " {}%";
            "max-length" = 10;
          };
          "wlr/workspaces" = {
            on-click = "activate";
            active-only = false;
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "10" = "10";
              # "active" = "";
              "default" = "";
            };
          };
          "sway/workspaces" = {
            on-click = "activate";
            active-only = false;
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "10" = "10";
              # "active" = "";
              "default" = "";
            };
          };
          "tray" = {
            spacing = 5;
          };
          "network" = {
            interface = "wlp4s0";
            format-wifi = "  Connected";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪  Disconnected";
            tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
          };
          "battery" = {
            bat = "BAT1";
            interval = 60;
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            states = {
              "good" = 95;
              "warning" = 20;
              "critical" = 10;
            };
            format-icons = [
              " "
              " "
              ""
              " "
              " "
            ];
          };
          "custom/date" = {
            format = "  {}";
            interval = 3600;
            #exec = "${lib.getExe waybar-date}";
          };
          "clock" = {
            format = " {:%I:%M %p}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
      };
      style = import ./config/waybar/style.nix {inherit (config) colorscheme;};
    };
  };

  services = {
    dunst = {
      enable = true;
      package = inputs.nixpkgs-wayland.packages.${system}.dunst;

      iconTheme = {
        name = "Papirus";
        size = "32x32";
        package = pkgs.papirus-icon-theme;
      };

      settings = import ./config/dunst.nix {inherit (config) colorscheme;};
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    systemdIntegration = true;
    recommendedEnvironment = true;

    extraConfig = import ./config/hyprland.nix {inherit (config) colorscheme;};
  };

  xdg = {
    configFile = {
      "fuzzel/fuzzel.ini".text = ''
        font='Iosevka Nerd Font-16'
        icon-theme='Papirus-Dark'
        prompt='->'
        [dmenu]
        mode=text
        [colors]
        background=24283bff
        text=a9b1d6ff
        match=8031caff
        selection=8031caff
        selection-text=7aa2f7ff
        selection-match=2ac3deff
        border=8031caff

        [border]
        width=2
        radius=0
      '';

      "MangoHud/MangoHud.conf".text = ''
        gpu_stats
        cpu_stats
        fps
        frame_timing = 0
        throttling_status = 0
        position=top-right
      '';
    };
    userDirs = {
      enable = true;
    };
  };

  programs.home-manager.enable = true;
}
