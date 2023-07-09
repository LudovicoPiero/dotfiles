{
  self,
  config,
  pkgs,
  ...
}: {
  age.secrets = {
    userPassword.file = "${self}/secrets/userPassword.age";
    rootPassword.file = "${self}/secrets/rootPassword.age";
  };
  users = {
    mutableUsers = false;
    users = {
      root.passwordFile = config.age.secrets.rootPassword.path;
      "${config.vars.username}" = {
        shell = pkgs.fish;
        passwordFile = config.age.secrets.userPassword.path;
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
