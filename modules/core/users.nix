{
  config,
  pkgs,
  ...
}: {
  programs.fish.enable = true;
  users = {
    mutableUsers = false;
    users = {
      root.initialPassword = "1234";
      ludovico = {
        shell = pkgs.fish;
        initialPassword = "1234";
        isNormalUser = true;
        extraGroups =
          ["seat" "wheel"]
          ++ pkgs.lib.optional config.virtualisation.libvirtd.enable "libvirtd"
          ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager"
          ++ pkgs.lib.optional config.programs.light.enable "video";
      };
    };
  };
}
