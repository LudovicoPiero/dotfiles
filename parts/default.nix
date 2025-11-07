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
        fd . --exclude='packages' -t f -e nix -x ${lib.getExe' unfreePkgs.nixfmt "nixfmt"} -s '{}'

        ${log "Formatting *.lua files..."}
        fd . --exclude='packages' -t f -e lua -x ${lib.getExe' unfreePkgs.stylua "stylua"} \
          --indent-type Spaces --indent-width 2 '{}'

        ${log "Formatting *.sh files..."}
        fd . --exclude='packages' -t f -e sh -x ${lib.getExe unfreePkgs.shfmt} -w -i 2 '{}'

        ${log "Checking for dead code (deadnix)..."}
        fd . --exclude='packages' -t f -e nix -x ${lib.getExe unfreePkgs.deadnix} --no-lambda-arg --no-lambda-pattern-names -e '{}'

        ${log "Running statix (lint & fix)..."}
        fd . --exclude='packages' -t f -e nix -x ${lib.getExe unfreePkgs.statix} fix '{}'

        echo -e "${color.green}✨ All done!${color.reset}"
      '';
    in
    {
      formatter = formatScript;

      devShells.default = unfreePkgs.mkShell {
        name = "UwU Shell";
        buildInputs = with unfreePkgs; [
          nixfmt
          deadnix
          statix
          shfmt
          stylua
          nixd
          sops
        ];

        shellHook = ''
          echo -e "${color.yellow}🐚 Entered UwU Shell — happy hacking!${color.reset}"
        '';
      };
    };
}
