{
  config,
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = [
      inputs.nil.packages.${pkgs.system}.default
    ];
    programs.vscode = {
      enable = true;
      # package = pkgs.vscodium; # use vscode because copilot no worky :(
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc # Color theme
        pkief.material-icon-theme # Icons theme
        esbenp.prettier-vscode
      ];
    };
  };
}
