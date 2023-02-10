{
  config,
  pkgs,
  ...
}: let
  browser = "firefox";
  tmpdir = "/tmp";
  emacs-server = "${tmpdir}/emacs-emacs/server";
  emacsclient = "emacsclient -s ${emacs-server}";
in {
  home-manager.users."${config.vars.username}" = {
    home = {
      username = "${config.vars.username}";
      homeDirectory = "${config.vars.home}";
      inherit (config.system) stateVersion;
      sessionVariables = {
        EDITOR = "${emacsclient}";
        EMACS_SERVER_FILE = "${emacs-server}";
        PAGER = "less -R";
        TERM = "${config.vars.terminal}";
        BROWSER = "${browser}";
      };
      packages = with pkgs; [
        neofetch
      ];
    };
    programs.home-manager.enable = true;
  };
}
