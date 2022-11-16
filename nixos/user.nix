{ pkgs, ... }:
{
  users.users.ludovico = {
    isNormalUser = true;
    description = "ludovico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
}
