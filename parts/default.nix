{
  systems = [
    "x86_64-linux"
    # "aarch64-linux"
    # "aarch64-darwin"
    # "x86_64-darwin"
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;

    devShells.default = pkgs.mkShell {
      name = "UwU Shell";
      buildInputs = with pkgs; [
        alejandra
        nixd
        sops
      ];
    };

    packages.default = throw ''
      No packages are available in this repository.
      Perhaps https://github.com/ludovicopiero/nixpackages is what you're looking for?
    '';
  };
}
