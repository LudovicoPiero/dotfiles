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
      };
      packages = with pkgs; [
        neofetch
      ];
    };

    services.gnome-keyring.enable = true;

    programs.home-manager.enable = true;
  };
}
