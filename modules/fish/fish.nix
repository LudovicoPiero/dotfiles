{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    mkIf
    ;
  _ = getExe;
  cfg = config.mine.fish;
in
{
  options.mine.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Fish shell configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fish
      eza
      bat
      zoxide
    ];

    # Make the user use fish as default shell
    users.users.${config.mine.vars.username}.shell = pkgs.fish;
    environment.pathsToLink = [ "/share/fish" ];
    programs = {
      fish.enable = true;
      fish.useBabelfish = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        angrr.enable = config.services.angrr.enable;
      };
    };

    hj = {
      xdg.config.files = {
        "fish/config.fish".text = ''
          # Environment
          set -gx EDITOR nvim
          set -gx LESSHISTFILE "-"                    # Don't create ~/.lesshst
          set -gx WGETRC "$HOME/.config/wget/wgetrc"  # Move wget config

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

          # Disable greeting
          function fish_greeting
          end

          # Key bindings (Old fish behavior)
          bind alt-backspace backward-kill-word
          bind ctrl-alt-h backward-kill-word
          bind ctrl-backspace backward-kill-token
          bind alt-delete kill-word
          bind ctrl-delete kill-token

          # Aliases
          alias cat="${getExe pkgs.bat}"

          # Eza aliases
          alias ls="${getExe pkgs.eza} --icons=always"
          alias l="${getExe pkgs.eza} --icons=always -lF --git"
          alias la="${getExe pkgs.eza} --icons=always -la --git"
          alias ll="${getExe pkgs.eza} --icons=always --git"
          alias llm="${getExe pkgs.eza} --icons=always -lGF --git --sort=time"
          alias t="${getExe pkgs.eza} --icons=always --tree"
          alias tree="${getExe pkgs.eza} --icons=always --tree"

          alias nv="nvim"
          alias v="nvim"
          alias config="cd ~/Code/nixos"
          alias mkdir="mkdir -p"
          alias g="${getExe pkgs.git}"
          alias ..="cd .."
          alias ...="cd ../.."
        '';
      };
    };
  };
}
