{
  config,
  pkgs,
  ...
}: {
  home-manager.users."${config.vars.username}" = {
    home = {
      username = "${config.vars.username}";
      homeDirectory = "${config.vars.home}";
      stateVersion = config.system.stateVersion;
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "less -R";
        TERM = "${config.vars.terminal}";
        BROWSER = "firefox";
      };
      packages = with pkgs; [
        neofetch
      ];
    };
    programs.home-manager.enable = true;
  };
}
