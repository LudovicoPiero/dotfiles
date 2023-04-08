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
        #ms-vscode.cpptools # C/C++
        bbenoist.nix
        catppuccin.catppuccin-vsc # Color theme
        github.copilot
        kamadorueda.alejandra
        pkief.material-icon-theme # Icons theme
        esbenp.prettier-vscode
        eamodio.gitlens
      ];
    };
  };
}
