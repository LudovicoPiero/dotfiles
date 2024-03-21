{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  systemPackages = with nixpkgs; [ pavucontrol ];
}
