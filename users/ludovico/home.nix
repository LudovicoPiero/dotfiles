{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  imports = [
    ../shared/home.nix

    ../../modules/home-manager/emacs
  ];

  colorscheme = {
    slug = "Skeet";
    name = "Skeet";
    author = "Ludovico";
    colors =
      inputs.nix-colors.colorSchemes.catppuccin-mocha.colors
      // {
        blue = "1e5799";
        pink = "f300ff";
        yellow = "e0ff00";
        gray = "595959";
      };
  };

  fonts.fontconfig.enable = true;

  lv.emacs.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "${config.gtk.cursorTheme.name}";
    XCURSOR_SIZE = "24";
    DIRENV_LOG_FORMAT = "";
    SDL_VIDEODRIVER = "wayland";
    # needs qt5.qtwayland in systemPackages
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # Fix for some Java AWT applications (e.g. Android Studio),
    # use this if they aren't displayed properly:
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium; # with ungoogled, you can't install extensions from the settings below
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
        }
        {
          id = "ilcacnomdmddpohoakmgcboiehclpkmj";
          updateUrl = "https://raw.githubusercontent.com/FastForwardTeam/releases/main/update/update.xml";
        }
      ];
    };

    obs-studio = {
      enable = true;
      plugins = with inputs.nixpkgs-wayland.packages.${system}; [obs-wlrobs];
    };

    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;

      coc = {
        enable = true;
        settings = {
          # Disable coc suggestion
          definitions.languageserver.enable = false;
          suggest.autoTrigger = "none";

          # :CocInstall coc-discord-rpc
          # coc-discord-rpc
          rpc = {
            checkIdle = false;
            detailsViewing = "In {workspace_folder}";
            detailsEditing = "{workspace_folder}";
            lowerDetailsEditing = "Working on {file_name}";
          };
          # ...
        };
      };

      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        vim-nix
        plenary-nvim
        dashboard-nvim
        lualine-nvim
        nvim-tree-lua
        bufferline-nvim
        nvim-colorizer-lua
        impatient-nvim
        telescope-nvim
        indent-blankline-nvim
        # nvim-treesitter
        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-css
            tree-sitter-go
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-scss
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-yaml
          ]))
        comment-nvim
        vim-fugitive
        nvim-web-devicons
        lsp-format-nvim
        which-key-nvim

        gitsigns-nvim
        neogit

        # Cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        nvim-cmp
        nvim-lspconfig
        luasnip
        cmp_luasnip
      ];

      extraPackages = with pkgs; [
        alejandra
        lua-language-server
        stylua # Lua
        rust-analyzer
        gcc
        (ripgrep.override {withPCRE2 = true;})
        fd
      ];

      # https://github.com/fufexan/dotfiles/blob/main/home/editors/neovim/default.nix#L41
      extraConfig = let
        luaRequire = module:
          builtins.readFile (builtins.toString
            ./config/neovim/lua
            + "/${module}.lua");
        luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
          "cmp"
          # "copilot"
          "colorizer"
          "keybind"
          "settings"
          "theme"
          "ui"
          "which-key"
        ]);
      in ''
        set guicursor=n-v-c-i:block
        lua << EOF
        ${luaConfig}
        EOF
      '';
    };

    spicetify = let
      spicePkgs = inputs.spicetify.packages.${system}.default;
    in {
      enable = true;
      spotifyPackage = pkgs.spotify;
      theme = spicePkgs.themes.catppuccin-mocha;
      colorScheme = "flamingo";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
        adblock
      ];

      # enabledCustomApps = ["marketplace"];
    };

    foot = {
      enable = true;
      settings = import ./config/foot.nix {
        inherit (config) colorscheme;
      };
    };

    # wezterm = {
    #   enable = true;
    #   colorSchemes = import ./config/wezterm/colorscheme.nix {
    #     inherit (config) colorscheme;
    #   };
    #   extraConfig = import ./config/wezterm/config.nix {
    #     inherit (config) colorscheme;
    #   };
    # };

    fuzzel = {
      enable = true;
      settings = import ./config/fuzzel.nix {
        inherit (config) colorscheme;
        inherit config;
      };
    };

    tmux = {
      enable = true;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      extraConfig = import ./config/tmux.nix;
      plugins = [
        {
          plugin = pkgs.tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_flavour 'mocha'
            set -g @catppuccin_left_separator "█"
            set -g @catppuccin_right_separator "█"
            set -g @catppuccin_date_time "%Y-%m-%d %H:%M"
          '';
        }
      ];
    };

    firefox = {
      enable = true;

      profiles.ludovico =
        {
          isDefault = true;
          name = "Ludovico";
          extensions = with config.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            grammarly
          ];
          bookmarks = import ./config/firefox/bookmarks.nix;
          search = import ./config/firefox/search.nix {inherit pkgs;};
          settings = import ./config/firefox/settings.nix;
        }
        // (let
          inherit (config.nur.repos.federicoschonborn) firefox-gnome-theme;
        in {
          userChrome = ''@import "${firefox-gnome-theme}/userChrome.css";'';
          userContent = ''@import "${firefox-gnome-theme}/userContent.css";'';
          extraConfig = builtins.readFile "${firefox-gnome-theme}/configuration/user.js";
        });
    };

    i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          blocks = [
            {
              block = "cpu";
              format = " $icon $utilization ";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents.eng(w:1) ";
            }
            {
              block = "disk_space";
              path = "/";
              info_type = "available";
              alert_unit = "GB";
              interval = 20;
              warning = 20.0;
              alert = 10.0;
              format = " $icon ROOT: $available.eng(w:2) ";
            }
            {
              block = "net";
              device = "wlp4s0";
              format = " $icon DOWN: $speed_down UP: $speed_up ";
            }
            {
              block = "sound";
              # driver = "pulseaudio";
              format = " $icon $volume ";
            }
            {
              block = "battery";
              device = "BAT1";
              format = " $icon $percentage ";
            }
            {
              block = "time";
              format = " $icon $timestamp.datetime(f:'%a %d/%m %R') ";
            }
          ];
          settings = {
            theme = {
              theme = "solarized-dark";
              overrides = let
                inherit (config) colorscheme;
              in
                with colorscheme.colors; {
                  idle_bg = "#${base00}";
                  idle_fg = "#${base05}";
                  info_bg = "#${base0C}";
                  info_fg = "#${base00}";
                  good_bg = "#${base0B}";
                  good_fg = "#${base00}";
                  warning_bg = "#${base0A}";
                  warning_fg = "#${base00}";
                  critical_bg = "#${base08}";
                  critical_fg = "#${base00}";
                  separator = "<span font='12'></span>";
                };
            };
            icons = {
              icons = "awesome6";
              overrides = {
                tux = "";
                upd = "";
                noupd = "";
              };
            };
          };
        };
      };
    };

    # waybar = {
    #   enable = true;
    #   package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    #   settings = import ./config/waybar/settings.nix {
    #     inherit pkgs;
    #     inherit lib;
    #   };
    #   style = import ./config/waybar/style.nix {inherit (config) colorscheme;};
    # };
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

  # wayland.windowManager.hyprland = {
  #   enable = true;

  #   systemdIntegration = true;
  #   recommendedEnvironment = true;

  #   extraConfig = import ./config/hyprland.nix {
  #     inherit (config) colorscheme;
  #     inherit pkgs;
  #     inherit lib;
  #     inherit config;
  #   };
  # };

  wayland.windowManager.sway = let
    inherit (config) colorscheme;
  in {
    enable = true;
    package = inputs.swayfx.packages.${pkgs.system}.default;
    config = {
      colors = import ./config/sway/colors.nix {inherit colorscheme;};
      keybindings = import ./config/sway/keybindings.nix {inherit config lib pkgs;};
      bars = import ./config/sway/bars.nix {inherit colorscheme;};
      window = import ./config/sway/windows.nix;
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_options = "ctrl:nocaps";
          repeat_delay = "200";
          repeat_rate = "30";
        };
      };
      floating = {
        border = 2;
        titlebar = true;
        criteria = [
          {window_role = "pop-up";}
          {window_role = "bubble";}
          {window_role = "dialog";}
          {window_type = "dialog";}
          {app_id = "lutris";}
          {app_id = "thunar";}
          {app_id = "pavucontrol";}
          {class = ".*.exe";} # Wine apps
          {class = "steam_app.*";} # Steam games
          {class = "^Steam$";} # Steam itself
        ];
      };
      gaps = {
        inner = 2;
        outer = 2;
      };
      fonts = {
        names = ["Iosevka Nerd Font"];
        size = 10.0;
      };
      startup = [
        {command = "dunst";}
        {command = "systemctl --user restart swaybg.service";}
        {command = "systemctl --user restart xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland";}
      ];
      modifier = "Mod4";
    };
    extraConfig = ''
      titlebar_border_thickness 1
      title_align center
      titlebar_padding 2

      # SwayFX stuff
      # Blur
      blur enable
      blur_xray disable
      blur_passes 3
      blur_radius 3

      # window corner radius in px
      corner_radius 3

      shadows off
      shadows_on_csd off
      shadow_blur_radius 20
      shadow_color #0000007F

      # inactive window fade amount. 0.0 = no dimming, 1.0 = fully dimmed
      default_dim_inactive 0.0
      dim_inactive_colors.unfocused #000000FF
      dim_inactive_colors.urgent #900000FF

      # Treat Scratchpad as minimized
      # scratchpad_minimize enable
    '';
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    systemdIntegration = true;
  };

  xdg = {
    configFile."MangoHud/MangoHud.conf".text = ''
      gpu_stats
      cpu_stats
      fps
      frame_timing = 0
      throttling_status = 0
      position=top-right
    '';
    userDirs = {
      enable = true;
    };
  };

  # User Services
  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Images Wallpaper Daemon";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${../../assets/wallpaper/wolf.jpeg}";
        Restart = "on-failure";
      };
    };
    # mpvpaper = mkService {
    #   Unit.Description = "Video Wallpaper Daemon";
    #   Service = {
    #     ExecStart = "${lib.getExe pkgs.mpvpaper} -o \"no-audio --loop-playlist shuffle\" eDP-1 ${../../assets/wallpaper/wallpaper.mp4}";
    #     Restart = "on-failure";
    #   };
    # };
    cliphist = mkService {
      Unit.Description = "Clipboard History";
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "on-failure";
      };
    };
  };

  programs.home-manager.enable = true;
}
