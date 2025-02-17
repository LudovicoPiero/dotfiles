{
  systems = [
    "x86_64-linux"
    # "aarch64-linux"
    # "aarch64-darwin"
    # "x86_64-darwin"
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.nixfmt-rfc-style;

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
