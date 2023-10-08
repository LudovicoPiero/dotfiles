{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.arrpc.homeManagerModules.default];

  home.packages = [
    inputs.ludovico-nixpkgs.packages.${pkgs.system}.webcord-vencord
    inputs.ludovico-nixpkgs.packages.${pkgs.system}.vesktop
  ];

  services.arrpc.enable = true;
}
