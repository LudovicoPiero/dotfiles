{
  lib,
  pkgs,
  inputs,
  ...
} @ args: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less -R";
    TERM = "screen-256color";
    BROWSER = "firefox";
    XCURSOR_SIZE = "24";
    DIRENV_LOG_FORMAT = "";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland"; # needs qt5.qtwayland in systemPackages
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # Fix for some Java AWT applications (e.g. Android Studio),
    # use this if they aren't displayed properly:
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  home.packages = with pkgs; [
    # Utils
    qt6.qtwayland.out
    libsForQt5.qt5.qtwayland.out
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = import ./settings.nix args;
    xwayland.hidpi = true;
  };

  # User Services
  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Images Wallpaper Daemon";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${./Wallpaper/hypr-chan.png}";
        Restart = "always";
      };
    };
    wl-clip-persist = mkService {
      Unit.Description = "Keep Wayland clipboard even after programs close";
      Service = {
        ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard both";
        Restart = "on-failure";
      };
    };
  };
}
