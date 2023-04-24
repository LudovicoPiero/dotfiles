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
      inherit
        (pkgs)
        fuzzel
        bemenu
        discord-canary
        neofetch
        ripgrep
        mpv
        nitch
        exa
        fzf
        steam
        gamescope
        mangohud
        lutris
        protonup-qt
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

      inherit
        (inputs.nil.packages.${system})
        default
        ;

      inherit
        (inputs.hyprland-contrib.packages.${system})
        grimblast
        ;
    };

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      XCURSOR_SIZE = "24";
    };
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium; # with ungoogled, you can't install extensions from the settings below
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # uBlock Origin
        {id = "jhnleheckmknfcgijgkadoemagpecfol";} # Auto-Tab-Discard
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

    neovim = {
      enable = true;
      #TODO
      # package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
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
        copilot-lua
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

        gitsigns-nvim

        # Cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-vsnip
        vim-vsnip
        nvim-cmp
        nvim-lspconfig
      ];

      extraPackages = with pkgs; [
        nodejs-16_x # for copilot
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
          "copilot"
          "colorizer"
          "keybind"
          "settings"
          "theme"
          "ui"
        ]);
      in ''
        set guicursor=n-v-c-i:block
        lua << EOF
        ${luaConfig}
        EOF
      '';
    };

    spicetify = let
      spicePkgs = inputs.spicetify.packages.${pkgs.system}.default;
    in {
      enable = true;
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

    wezterm = {
      enable = true;
      extraConfig = import ./config/wezterm.nix {
        inherit (config) colorscheme;
      };
    };

    firefox = {
      enable = true;

      profiles.ludovico = {
        isDefault = true;
        name = "Ludovico";
        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          betterttv
          # fastforward
        ];
        bookmarks = import ./config/firefox/bookmarks.nix;
        search = import ./config/firefox/search.nix {inherit pkgs;};
        settings = import ./config/firefox/settings.nix;
        userChrome = import ./config/firefox/userChrome.nix;
      };
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
          "custom/date" = let
            waybar-date = pkgs.writeShellScriptBin "waybar-date" ''
              date "+%a %d %b %Y"
            '';
          in {
            format = "  {}";
            interval = 3600;
            exec = "${lib.getExe waybar-date}";
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

  home.file = {
    ".icons/default/index.theme".text = ''
      [icon theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=capitaine-cursors-white
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Catppuccin-Mocha-Compact-Pink-Dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "capitaine-cursors-white";
    };
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
