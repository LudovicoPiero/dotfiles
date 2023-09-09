{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = [
    inputs.nixpkgs.legacyPackages.${pkgs.system}.webcord-vencord
  ];

  services.arrpc.enable = true;
}
