{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    optionalString
    ;

  _ = getExe;

  cfg = config.mine.fish;
in
{
  options.mine.fish = {
    enable = mkEnableOption "Fish Shell";
  };

  config = mkIf cfg.enable {
    users.users.root.shell = pkgs.fish;
    users.users.${config.vars.username}.shell = pkgs.fish;

    sops = {
      secrets."shells/githubToken" = {
        mode = "0444";
      };
    };

    environment.pathsToLink = [ "/share/fish" ];

    programs = {
      fish.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        angrr.enable = config.services.angrr.enable;
      };
    };

    hj = {
      packages = with pkgs; [
        zoxide
        fzf
        fd
        bat
        lazygit
      ];

      xdg.config.files."fish/config.fish".text = ''
        if test -f ${config.sops.secrets."shells/githubToken".path}
          source ${config.sops.secrets."shells/githubToken".path}
        end

        set -U fish_greeting

        ${optionalString (!config.vars.withGui && config.vars.isALaptop) ''
          ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
        ''}

        if status is-interactive
          ${_ pkgs.starship} init fish | source
          ${_ pkgs.nix-your-shell} fish | source
          ${_ pkgs.zoxide} init fish | source
          ${_ pkgs.direnv} hook fish | source

          set -p fish_function_path ${pkgs.fishPlugins.fzf-fish}/share/fish/vendor_functions.d
          set -p fish_complete_path ${pkgs.fishPlugins.fzf-fish}/share/fish/vendor_completions.d
          source ${pkgs.fishPlugins.fzf-fish}/share/fish/vendor_conf.d/fzf.fish

          if functions -q fzf_configure_bindings
            fzf_configure_bindings --directory=\eF --git_log=\cg --history=\cr --variables=\cv
          end
        end
      '';
    };
  };
}
