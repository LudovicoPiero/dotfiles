{
  systems = [
    "x86_64-linux"
    # "aarch64-linux"
    # "aarch64-darwin"
    # "x86_64-darwin"
  ];

  perSystem =
    { pkgs, lib, ... }:
    {
      formatter = pkgs.writeShellScriptBin "formatter" ''
        echo "Formatting *.nix files (excluding packages/)..."
        fd . -t f -e nix --exclude packages/ -x ${lib.getExe' pkgs.nixfmt-rfc-style "nixfmt"} -s '{}'

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
