{
  pkgs,
  lib,
  inputs,
  ...
}: let
in {
  colorScheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;

  home = {
    sessionVariables = {
      # Colorific GCC.
      GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";

      # https://ayats.org/blog/channels-to-flakes/
      NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";

      NIXOS_OZONE_WL = "0";
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less -R";
      TERM = "screen-256color";
      BROWSER = "firefox";
      XCURSOR_SIZE = "24";
      DIRENV_LOG_FORMAT = "";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    packages = lib.attrValues {
      inherit (inputs.chaotic.packages.${pkgs.system}) telegram-desktop_git;

      inherit
        (pkgs)
        authy
        mpv
        mailspring
        imv
        viewnior
        element-desktop
        whatsapp-for-linux
        qbittorrent
        ;

      inherit (pkgs.libsForQt5) kleopatra; # Gui for GPG

      # Utils
      sharenix = pkgs.writeShellScriptBin "sharenix" ''${builtins.readFile ./scripts/sharenix}'';

      # use OCR and copy to clipboard
      ocrScript = let
        inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
        _ = lib.getExe;
      in
        pkgs.writeShellScriptBin "wl-ocr" ''
          ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
          ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
        '';
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
    ];
  };
}
