{
  pkgs,
  lib,
  inputs,
  config,
  pkgs-stable,
  pkgs-master,
  ...
}:
let
  cfg = config.mine.games;
in
{
  options.mine.games = {
    nix-ld.enable = lib.mkEnableOption "nix-ld, a dynamic linker for Nix";
    steam.enable = lib.mkEnableOption "Steam gaming platform";
    lutris.enable = lib.mkEnableOption "Lutris game manager";
    gamemode.enable = lib.mkEnableOption "Feral gamemode";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.nix-ld.enable {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          # Albion Online
          libxrandr
          libx11
          libGL
          krb5
          glib
        ];
      };
    })

    (lib.mkIf cfg.steam.enable {
      programs.steam = {
        enable = true;
        package = pkgs-stable.steam;
      };

      environment.systemPackages = with pkgs-master; [ samrewritten ];
      hardware.steam-hardware.enable = true;

      # Required for Steam's 32-bit OpenGL/Vulkan to work correctly
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    (lib.mkIf cfg.lutris.enable {
      environment.systemPackages = [
        (pkgs-stable.lutris.override {
          extraPkgs = p: [
            p.wine
            p.pixman
            p.libjpeg
            p.zenity
            p.umu-launcher
            p.mangohud
            p.winetricks
            p.curl
            p.wget
            p.gnutar
            p.gzip
            p.zstd
            p.xz
            p.p7zip
            p.libadwaita
            p.zenity
            p.gamescope
            p.which
            p.file
            p.zenity
            p.vulkan-loader
            p.vulkan-tools
            p.unzip
            p.cabextract
            p.pciutils
            p.gamemode.lib
            p.xdg-utils
            p.umu-launcher
            p.sdl3
          ];
        })
      ];
    })

    (lib.mkIf cfg.gamemode.enable (
      let
        gamemodePrograms = lib.makeBinPath (
          with pkgs;
          [
            gojq
            systemd
          ]
        );

        startscript = pkgs.writeShellScript "gamemode-start" ''
          export PATH=$PATH:${gamemodePrograms}
          ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'
        '';

        endscript = pkgs.writeShellScript "gamemode-end" ''
          export PATH=$PATH:${gamemodePrograms}
          ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'
        '';
      in
      {
        programs.gamemode = {
          enable = true;
          enableRenice = true;
          settings = {
            general = {
              softrealtime = "auto";
              renice = 15;
            };
            custom = {
              start = startscript.outPath;
              end = endscript.outPath;
            };
          };
        };
      }
    ))
  ];
}
