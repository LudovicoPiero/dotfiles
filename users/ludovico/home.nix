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

  home = {
    packages = lib.attrValues {
      inherit
        (pkgs)
        catgirl
        discord-canary
        exa
        fuzzel
        fzf
        gamescope
        lutris
        mangohud
        mpv
        neofetch
        nitch
        protonup-qt
        ripgrep
        steam
        thunderbird
        webcord
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
        (inputs.ludovico-main.packages.${system})
        TLauncher
        ;

      # use OCR and copy to clipboard
      ocrScript = let
        inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
        _ = lib.getExe;
      in
        pkgs.writers.writeDashBin "wl-ocr" ''
          ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
          ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
        '';
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
      spotifyPackage = inputs.fufexan-dotfiles.packages.${system}.spotify;
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
      settings = import ./config/waybar/settings.nix {
        inherit pkgs;
        inherit lib;
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

    extraConfig = import ./config/hyprland.nix {
      inherit (config) colorscheme;
      inherit pkgs;
      inherit lib;
      inherit config;
    };
  };

  xdg = {
    configFile = let
      inherit (config.colorscheme) colors;
    in {
      "fuzzel/fuzzel.ini".text = ''
        font='Iosevka Nerd Font-16'
        icon-theme='WhiteSur-dark'
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
