{ pkgs, userName, ... }:
{
  imports = [
    ./gamemode.nix
    ./lutris.nix
    ./steam.nix
  ];

  environment.systemPackages = with pkgs; [ mangohud ];

  systemd.user.tmpfiles.users.${userName}.rules = [
    "L+ %h/.config/MangoHud/MangoHud.conf 0644 ${userName} users - ${./MangoHud.conf}"
  ];
}
