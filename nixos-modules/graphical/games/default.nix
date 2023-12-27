{ pkgs, ... }:
{
  imports = [
    ./gamemode.nix
    ./lutris.nix
    ./steam.nix
  ];

  environment.systemPackages = with pkgs; [ mangohud ];

  systemd.user.tmpfiles.users.airi.rules = [
    "L+ %h/.config/MangoHud/MangoHud.conf 0644 airi users - ${./MangoHud.conf}"
  ];
}
