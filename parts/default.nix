{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    {
      # This sets `pkgs` to a nixpkgs with allowUnfree option set.
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ ];
        config.allowUnfree = true;
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        echo "Formatting *.nix files..."
        fd . -t f -e nix -x ${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"} -s '{}'

        echo "Running deadnix for *.nix files..."
        fd . -t f -e nix -x ${lib.getExe pkgs.deadnix} -e '{}'

        echo "Running statix for *.nix files..."
        fd . -t f -e nix -x ${lib.getExe pkgs.statix} -e '{}'

        echo "Formatting *.html files..."
        fd . -t f -e html -x ${lib.getExe pkgs.nodePackages.prettier} --write '{}'

        echo "Formatting *.sh files..."
        fd . -t f -e sh -x ${lib.getExe pkgs.shfmt} -w -i 2 '{}'
      '';

      devShells.default = pkgs.mkShell {
        name = "UwU Shell";
        buildInputs = with pkgs; [
          nixfmt-rfc-style
          nixd
          sops
        ];
      };
    };
}
