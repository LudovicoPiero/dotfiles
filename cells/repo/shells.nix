/*
  This file holds reproducible shells with commands in them.

  They conveniently also generate config files in their startup hook.
*/
{ inputs, cell }:
let
  inherit (inputs.std) lib;
in
builtins.mapAttrs (_: lib.dev.mkShell) {
  # Tool Homepage: https://numtide.github.io/devshell/
  default = {
    name = "Hiveland";

    motd = inputs.nixpkgs.lib.mkForce ''
      {202}🔨 Welcome to Hiveland{reset}

      $(type -p menu &>/dev/null && menu)
    '';

    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = with cell.configs; [
      editorconfig
      lefthook
      treefmt
    ];

    packages = with inputs.nixpkgs; [
      commitizen
      sops
    ];

    commands = [
      {
        help = "Format the source tree with treefmt";
        name = "fmt";
        command = "treefmt";
        category = "formatter";
      }
      {
        help = "Commit staged changes using commitizen";
        name = "c";
        command = "cz c -- -s";
        category = "source control";
      }
      {
        help = "Fetch source from origin";
        name = "pl";
        command = "git pull";
        category = "source control";
      }
      {
        help = "Push commited changes to git";
        name = "ps";
        command = "git push";
        category = "source control";
      }
    ];

    env = [
      # {
      #   # make direnv shut up
      #   name = "DIRENV_LOG_FORMAT";
      #   value = "";
      # }
      {
        # Just in case
        name = "EDITOR";
        value = "nvim";
      }
    ];
  };
}
