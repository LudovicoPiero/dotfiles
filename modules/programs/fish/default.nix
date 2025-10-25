{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  inherit (lib) mkEnableOption mkIf optionalString;

  cfg = config.myOptions.fish;
in
{
  options.myOptions.fish = {
    enable = mkEnableOption "Fish Shell" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    users.users.root.shell = pkgs.fish;
    users.users.${config.vars.username}.shell = pkgs.fish;
    sops.secrets."shells/githubToken" = {
      mode = "0444";
    };
    environment.pathsToLink = [ "/share/fish" ];
    programs.fish.enable = true;

    hj = {
      packages = with pkgs; [
        zoxide
        fzf
        fd
        bat
        lazygit
      ];

      xdg.config.files."fish/config.fish".text =
        with pkgs;
        ''
          function fish_greeting
          end

          set -gx GNUPGHOME $HOME/.config/gnupg
          set -gx EDITOR nvim

          alias v nvim
          alias g git
          alias c 'cd $HOME/Code/nixos'
          alias config 'cd $HOME/Code/nixos'

          . ${config.sops.secrets."shells/githubToken".path}
          ${_ nix-your-shell} fish | source
          ${_ starship} init fish | source
          ${_ zoxide} init fish | source
          ${_ direnv} hook fish | source
        ''
        +
          optionalString (!config.vars.withGui && config.vars.isALaptop)
            # Automatically turn off screen after 1 minute. (For laptop)
            ''
              ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
            '';
    };
  };
}
