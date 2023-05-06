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
  # use OCR and copy to clipboard
  ocrScript = let
    inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
    _ = lib.getExe;
  in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';
in {
  imports = [
    ../shared/home.nix

    ../../modules/home-manager/emacs
  ];

  colorscheme = inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark;

  fonts.fontconfig.enable = true;

  lv.emacs.enable = true;

  home = {
    packages = lib.attrValues {
      inherit
        (pkgs)
        fuzzel
        bemenu
        discord-canary
        webcord
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

      inherit
        (inputs.ludovico-dotfiles.packages.${system})
        TLauncher
        google-sans
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
      spicePkgs = inputs.spicetify.packages.${system}.default;
    in {
      enable = true;
      spotifyPackage = inputs.ludovico-dotfiles.packages.${system}.spotify;
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
      colorSchemes = import ./config/wezterm/colorscheme.nix {
        inherit (config) colorscheme;
      };
      extraConfig = import ./config/wezterm/config.nix {
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
            "custom/vpn"
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
          "custom/vpn" = {
            "format" = "Wireguard ";
            "exec" = "echo '{\"class\": \"connected\"}'";
            "exec-if" = "test -d /proc/sys/net/ipv4/conf/wg0";
            "return-type" = "json";
            "interval" = 5;
          };
          "network" = {
            # interface = "wlp4s0";
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

  xdg = {
    configFile = let
      inherit (config.colorscheme) colors;
    in {
      "fuzzel/fuzzel.ini".text = ''
        font='Iosevka Nerd Font-16'
        icon-theme='Papirus-Dark'
        prompt='->'
        [dmenu]
        mode=text
        [colors]
        background=${colors.base00}ff
        text=${colors.base07}ff
        match=${colors.base0E}ff
        selection=${colors.base08}ff
        selection-text=${colors.base07}ff
        selection-match=${colors.base07}ff
        border=${colors.base0E}ff

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

  # User Services
  systemd.user.services = {
    # swaybg = mkService {
    #   Unit.Description = "Images Wallpaper Daemon";
    #   Service = {
    #     ExecStart = "${lib.getExe pkgs.swaybg} -i ${./Wallpaper/wallpaper.jpg}";
    #     Restart = "always";
    #   };
    # };
    mpvpaper = mkService {
      Unit.Description = "Video Wallpaper Daemon";
      Service = {
        ExecStart = "${lib.getExe pkgs.mpvpaper} -o \"no-audio --loop-playlist shuffle\" eDP-1 ${../../assets/wallpaper/wallpaper.mp4}";
        Restart = "always";
      };
    };
    cliphist = mkService {
      Unit.Description = "Clipboard History";
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "always";
      };
    };
  };

  programs.home-manager.enable = true;
}
