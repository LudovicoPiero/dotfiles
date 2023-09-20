{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = [
    inputs.ludovico-nixpkgs.packages.${pkgs.system}.webcord-vencord
  ];

  services.arrpc.enable = true;
}
