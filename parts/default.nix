{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { lib, system, ... }:
    let
      # Import nixpkgs with unfree packages allowed
      unfreePkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ ];
        config.allowUnfree = true;
      };

      # Helper to print pretty log messages
      color = {
        blue = "\\033[1;34m";
        green = "\\033[1;32m";
        yellow = "\\033[1;33m";
        red = "\\033[1;31m";
        reset = "\\033[0m";
      };

      log = msg: "echo -e \"${color.blue}▶${color.reset} ${msg}\"";

      # Format all files nicely
      formatScript = unfreePkgs.writeShellScriptBin "formatter" ''
        set -euo pipefail

        ${log "Formatting *.nix files..."}
        fd . -t f -e nix -x ${lib.getExe' unfreePkgs.nixfmt-rfc-style "nixfmt"} -s '{}'

        ${log "Checking for dead code (deadnix)..."}
        fd . -t f -e nix -x ${lib.getExe unfreePkgs.deadnix} -e '{}'

        ${log "Running statix (lint & fix)..."}
        fd . -t f -e nix -x ${lib.getExe unfreePkgs.statix} fix '{}'

        ${log "Formatting *.sh files..."}
        fd . -t f -e sh -x ${lib.getExe unfreePkgs.shfmt} -w -i 2 '{}'

        echo -e "${color.green}✨ All done!${color.reset}"
      '';
    in
    {
      _module.args.pkgs = unfreePkgs;

      formatter = formatScript;

      devShells.default = unfreePkgs.mkShell {
        name = "UwU Shell";
        buildInputs = with unfreePkgs; [
          nixfmt
          nixd
          sops
        ];

        shellHook = ''
          echo -e "${color.yellow}🐚 Entered UwU Shell — happy hacking!${color.reset}"
        '';
      };
    };
}
