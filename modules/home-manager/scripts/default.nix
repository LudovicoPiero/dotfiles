{
  lib,
  pkgs,
  ...
}:
with lib; let
  screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
  bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
  maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';
in {
  home.packages = with pkgs; [
    ripgrep
    ffmpeg
    tealdeer
    exa
    htop
    pass
    gnupg
    unzip
    lowdown
    zk
    grim
    python3
    slurp
    slop
    imagemagick
    age
    libnotify
    git
    lua
    mpv
    pqiv
    screen
    bandw
    maintenance
    wf-recorder
    anki-bin
  ];
}
