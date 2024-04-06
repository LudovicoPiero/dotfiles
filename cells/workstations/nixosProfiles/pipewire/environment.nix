{ pkgs, ... }:
{
  systemPackages = with pkgs; [ pavucontrol ];
}
