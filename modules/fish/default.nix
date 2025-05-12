{
  config,
  pkgs,
  lib,
  ...
}:
let
  _ = lib.getExe;

  inherit (lib)
    mkForce
    mkEnableOption
    mkIf
    optionalString
    ;

  cfg = config.myOptions.fish;
in
{

  imports = [
    ./functions.nix
    ./shellAliases.nix
  ];

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
    programs.fish = {
      enable = true;
      shellAliases = mkForce { };
      interactiveShellInit =
        ''
          . ${config.sops.secrets."shells/githubToken".path}
        ''
        + optionalString (!config.vars.withGui && config.vars.isALaptop) ''
          ${pkgs.util-linux}/bin/setterm -blank 1 --powersave on
        '';

    };

    hj = {
      packages = with pkgs; [
        zoxide
        fzf
        fd
        bat
        lazygit
      ];

      rum.programs = {
        fish = {
          enable = true;

          config = with pkgs; ''
            function fish_greeting
            end


            set --universal pure_check_for_new_release false
            set --universal pure_enable_nixdevshell true
            set --universal pure_show_prefix_root_prompt true

            ${_ zoxide} init fish | source
            ${_ fzf} --fish | source
            ${_ direnv} hook fish | source
            ${_ nix-your-shell} fish | source
          '';

          plugins = {
            inherit (pkgs.fishPlugins) async-prompt;
            pure = pkgs.fishPlugins.pure.overrideAttrs {
              nativeCheckInputs = [ ];
              checkPlugins = [ ];
              checkPhase = "";
            };
          };
        };
      };
    };
  };
}
