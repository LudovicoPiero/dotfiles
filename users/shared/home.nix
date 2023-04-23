{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: {
  home = {
    packages = lib.attrValues {
      inherit
        (pkgs)
        bat
        alejandra
        ;
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      exa = {
        enable = true;
        enableAliases = true;
      };

      home-manager.enable = true;

      starship = {
        enable = true;
        settings = import ./config/starship.nix;
      };

      zsh = {
        enable = true;
        autocd = true;
        enableAutosuggestions = true;

        history = {
          expireDuplicatesFirst = true;
          extended = true;
          save = 10000;
        };

        initExtra = ''''; #TODO

        plugins = [];
        shellAliases = import ./config/sh-aliases.nix;
      };
    };
  };
}
