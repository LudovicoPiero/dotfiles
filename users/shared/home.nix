{
  config,
  lib,
  pkgs,
  ...
}: rec {
  home = {
    packages = lib.attrValues {
      inherit
        (pkgs)
        alejandra
        alsa-utils
        bat
        brightnessctl
        exa
        fzf
        playerctl
        ;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  gtk = {
    enable = true;
    font.name = "Google Sans Medium";

    iconTheme = {
      package = pkgs.whitesur-icon-theme;
      name = "WhiteSur-dark";
    };

    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
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

  home.file = {
    ".icons/default/index.theme".text = ''
      [icon theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${gtk.cursorTheme.name}
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "${gtk.theme.name}";
      icon-theme = "${gtk.iconTheme.name}";
      cursor-theme = "${gtk.cursorTheme.name}";
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    git = {
      enable = true;

      userEmail = "ludovicopiero@pm.me";
      userName = "Ludovico";

      signing = {
        key = "3911DD276CFE779C";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };

      aliases = {
        a = "add -p";
        co = "checkout";
        cob = "checkout -b";
        f = "fetch -p";
        c = "commit -s";
        p = "push";
        ba = "branch -a";
        bd = "branch -d";
        bD = "branch -D";
        d = "diff";
        dc = "diff --cached";
        ds = "diff --staged";
        r = "restore";
        rs = "restore --staged";
        st = "status -sb";

        # reset
        soft = "reset --soft";
        hard = "reset --hard";
        s1ft = "soft HEAD~1";
        h1rd = "hard HEAD~1";

        # logging
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
        tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
        rank = "shortlog -sn --no-merges";

        # delete merged branches
        bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.configHome}/gnupg";
    };

    home-manager.enable = true;

    starship = {
      enable = true;
      settings = import ./config/starship.nix {inherit lib;};
    };

    nix-index.enable = true;
    fish = {
      enable = true;
      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        fish_greeting = ""; # disable welcome text
        run = "nix run nixpkgs#$argv";
        "watchLive" = let
          args = "--hwdec=dxva2 --gpu-context=d3d11 --no-keepaspect-window --keep-open=no --force-window=yes --force-seekable=yes --hr-seek=yes --hr-seek-framedrop=yes";
        in "${lib.getExe pkgs.streamlink} --player ${lib.getExe pkgs.mpv} --twitch-disable-hosting --twitch-low-latency --player-args \"${args}\" --player-continuous-http --player-no-close --hls-live-edge 2 --stream-segment-threads 2 --retry-open 15 --retry-streams 15 $argv best -a --ontop -a --no-border";
      };
      interactiveShellInit = with pkgs; let
        _ = lib.getExe;
      in ''
        ${_ starship} init fish | source
        ${_ any-nix-shell} fish --info-right | source
        ${_ direnv} hook fish | source
      '';
      shellAliases = with pkgs; {
        "bs" = "pushd ~/.config/nixos && doas nixos-rebuild switch --flake ~/.config/nixos && popd";
        "bb" = "pushd ~/.config/nixos && doas nixos-rebuild boot --flake ~/.config/nixos && popd";
        "hs" = "pushd ~/.config/nixos && home-manager switch --flake ~/.config/nixos && popd";
        "cat" = lib.getExe bat;
        "config" = "cd ~/.config/nixos";
        "lg" = "lazygit";
        # "ls" = "exa --icons";
        # "l" = "${md} exa -lbF --git --icons";
        # "ll" = "${md} exa -lbGF --git --icons";
        # "llm" = "${md} exa -lbGF --git --sort=modified --icons";
        # "la" = "${md} exa -lbhHigUmuSa --time-style=long-iso --git --color-scale --icons";
        # "lx" = "${md} exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons";
        "tree" = "exa --tree --icons";
        "nv" = "nvim";
        "mkdir" = "mkdir -p";
        "g" = "git";
        "gcl" = "git clone";
        "gcm" = "cz c";
        "gd" = "git diff HEAD";
        "gpl" = "git pull";
        "gpsh" = "git push -u origin";
        "gs" = "git status";
        "sudo" = "doas";
        "..." = "cd ../..";
        ".." = "cd ..";
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
  };

  systemd.user = {
    timers.nix-index-db-update = {
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = 0;
      };
    };
    services.nix-index-db-update = {
      Unit = {
        Description = "nix-index database update";
        PartOf = ["multi-user.target"];
      };
      Service = let
        script = pkgs.writeShellScript "nix-index-update-db" ''
          export filename="index-x86_64-$(uname | tr A-Z a-z)"
          mkdir -p ~/.cache/nix-index
          cd ~/.cache/nix-index
          # -N will only download a new version if there is an update.
          wget -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
          ln -f $filename files
        '';
      in {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath [pkgs.wget pkgs.coreutils]}";
        ExecStart = "${script}";
      };
      Install.WantedBy = ["multi-user.target"];
    };
  };

  xdg = let
    browser = ["firefox.desktop"];
    thunderbird = ["thunderbird.desktop"];

    # XDG MIME types
    associations = {
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/x-extension-xht" = browser;
      "application/x-extension-xhtml" = browser;
      "application/xhtml+xml" = browser;
      "text/html" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
      "x-scheme-handler/ftp" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/unknown" = browser;

      "audio/*" = ["mpv.desktop"];
      "video/*" = ["mpv.dekstop"];
      "image/*" = ["imv.desktop"];
      "application/json" = browser;
      "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
      "x-scheme-handler/discord" = ["discordcanary.desktop"];
      "x-scheme-handler/spotify" = ["spotify.desktop"];
      "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
      "x-scheme-handler/mailto" = thunderbird;
      "message/rfc822" = thunderbird;
      "x-scheme-handler/mid" = thunderbird;
    };
  in {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        XDG_MISC_DIR = "${config.home.homeDirectory}/Stuff";
      };
    };
  };
}
