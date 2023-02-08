# This Config is Heavily Based on the Config of sioodmy
# https://github.com/sioodmy/dotfiles
# And ocrScript is from fufexan's dotfiles
{
  lib,
  pkgs,
  config,
  inputs,
  ...
} @ args: let
  inherit (config.vars.colorScheme) colors;
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
  bemenu-launch = pkgs.writeShellScriptBin "bemenu-launch" ''${builtins.readFile ./scripts/bemenu}'';
  powermenu-launch = pkgs.writeShellScriptBin "powermenu-launch" ''${builtins.readFile ./scripts/powermenu}'';
in {
  home-manager.users."${config.vars.username}" = {
    #home.packages = with pkgs; [
    #  # Utils
    #  inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    #  grim
    #  slurp
    #  ocrScript
    #  bemenu
    #  bemenu-launch
    #  powermenu-launch
    #];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      systemdIntegration = true;
      extraConfig = import ./config.nix args;
    };

    # User Services
    systemd.user.services = {
      swaybg = mkService {
        Unit.Description = "Images Wallpaper Daemon";
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${./Wallpaper/wallpaper.jpg}";
          Restart = "always";
        };
      };
      # mpvpaper = mkService {
      #   Unit.Description = "Video Wallpaper Daemon";
      #   Service = {
      #     ExecStart = "${lib.getExe pkgs.mpvpaper} -o \"no-audio --loop-playlist shuffle\" eDP-1 ${./Wallpaper/wallpaper.mp4}";
      #     Restart = "always";
      #   };
      # };
      cliphist = mkService {
        Unit.Description = "Clipboard History";
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
          Restart = "always";
        };
      };
    };
  };
}
