{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  gamemodePrograms = lib.makeBinPath (
    with pkgs;
    [
      sway
      gojq
      systemd
    ]
  );

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=$PATH:${gamemodePrograms}
    swaymsg "blur disable; shadows disable"
    ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=$PATH:${gamemodePrograms}
    swaymsg "blur enable; shadows enable"
    ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'
  '';
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];

  hm = {
    programs.lutris = {
      enable = true;
      winePackages = [
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-cachyos
      ];
      protonPackages = [ pkgs.proton-ge-bin ];
      extraPackages = with pkgs; [
        pixman
        libjpeg
        zenity
        umu-launcher
        mangohud
        winetricks
        curl
        wget
        gnutar
        gzip
        zstd
        xz
        p7zip
        libadwaita
        gamescope
        which
        file
        vulkan-loader
        vulkan-tools
        unzip
        cabextract
        pciutils
        gamemode.lib
        xdg-utils
        sdl3
      ];
    };
  };

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
