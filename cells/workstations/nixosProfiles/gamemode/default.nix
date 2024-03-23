{
  lib,
  inputs,
}: let
  inherit (inputs) nixpkgs;
in {
  programs.gamemode = let
    programs = lib.makeBinPath (
      with nixpkgs; [
        gojq
        systemd
      ]
    );

    startscript = nixpkgs.writeShellScript "gamemode-start" ''
      export PATH=$PATH:${programs}
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur:enabled 0 ; keyword animations:enabled 0'
      ${nixpkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'
      ${lib.getExe' nixpkgs.mako "makoctl"} mode -a dnd
    '';

    endscript = nixpkgs.writeShellScript "gamemode-end" ''
      export PATH=$PATH:${programs}
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur:enabled 1 ; keyword animations:enabled 1'
      ${lib.getExe' nixpkgs.mako "makoctl"} mode -r dnd
      ${nixpkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'
    '';
  in {
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
