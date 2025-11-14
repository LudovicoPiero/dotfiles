{
  systems = [ "x86_64-linux" ];

  perSystem =
    { lib, pkgs, ... }:
    let
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
      formatScript = pkgs.writeShellScriptBin "formatter" ''
        set -euo pipefail

        ${log "Formatting *.nix files..."}
        ${lib.getExe pkgs.fd} . --exclude='_*' -t f -e nix -x ${lib.getExe' pkgs.nixfmt "nixfmt"} --strict --width=80 '{}'

        ${log "Formatting *.lua files..."}
        ${lib.getExe pkgs.fd} . --exclude='_*' -t f -e lua -x ${lib.getExe' pkgs.stylua "stylua"} \
          --indent-type Spaces --indent-width 2 '{}'

        ${log "Formatting *.sh files..."}
        ${lib.getExe pkgs.fd} . --exclude='_*' -t f -e sh -x ${lib.getExe pkgs.shfmt} -w -i 2 '{}'

        ${log "Checking for dead code (deadnix)..."}
        ${lib.getExe pkgs.fd} . --exclude='_*' -t f -e nix -x ${lib.getExe pkgs.deadnix} --no-lambda-arg --no-lambda-pattern-names -e '{}'

        ${log "Running statix (lint & fix)..."}
        ${lib.getExe pkgs.fd} . --exclude='_*' -t f -e nix -x ${lib.getExe pkgs.statix} fix '{}'

        echo -e "${color.green}✨ All done!${color.reset}"
      '';
    in
    {
      formatter = formatScript;

      devShells.default = pkgs.mkShell {
        name = "UwU Shell";
        buildInputs = with pkgs; [
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
