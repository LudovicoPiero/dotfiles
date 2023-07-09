{
  config,
  pkgs,
  ...
}: let
  browser = "firefox";
in {
  home-manager.users."${config.vars.username}" = {
    home = {
      username = "${config.vars.username}";
      homeDirectory = "${config.vars.home}";
      inherit (config.system) stateVersion;
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "less -R";
        TERM = "${config.vars.terminal}";
        BROWSER = "${browser}";
        XCURSOR_SIZE = "24";
        DIRENV_LOG_FORMAT = "";
        SDL_VIDEODRIVER = "wayland";
        # needs qt5.qtwayland in systemPackages
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
      packages = with pkgs; [
        neofetch
      ];
    };

    programs.home-manager.enable = true;
  };
}
