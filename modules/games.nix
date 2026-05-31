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
    steam.enable = lib.mkEnableOption "Steam gaming platform";
    lutris.enable = lib.mkEnableOption "Lutris game manager";
    gamemode.enable = lib.mkEnableOption "Feral gamemode with Hyprland integration";
  };

  config = lib.mkMerge [
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
          ];
        })
      ];
    })

    (lib.mkIf cfg.gamemode.enable (
      let
        gamemodePrograms = lib.makeBinPath (
          with pkgs;
          [
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default
            gojq
            systemd
          ]
        );

        startscript = pkgs.writeShellScript "gamemode-start" ''
          export PATH=$PATH:${gamemodePrograms}
          export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
          hyprctl --batch 'keyword decoration:blur:enabled 0 ; keyword animations:enabled 0'
          ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'
        '';

        endscript = pkgs.writeShellScript "gamemode-end" ''
          export PATH=$PATH:${gamemodePrograms}
          export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
          hyprctl --batch 'keyword decoration:blur:enabled 1 ; keyword animations:enabled 1'
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
