{
  config,
  lib,
  pkgs,
  options,
  input,
  sytem,
  ...
}: {
  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$6$q6aVT9DEdwux5RuN$L2gzdL6EgMh6/gZisV0nDIU.f71x3cKTlZ9NWsD0urdntVb7AxTCVlW/jwAKQfKaAn9rCh47fKqD74gSEIR8s.";
    users.ludovico = {
      hashedPassword = "$6$lWUeoIB0ygj2rDad$V5Bc.OB7tTpOEImflTmb0DqoKBmTVTK6PnqfhuG8YO0IjioC1pdFyFoDdInlM8NXrES5lmxGjBt9CSySxrsOj0";
      isNormalUser = true;
      home = "/home/ludovico";
      # shell = pkgs.zsh;

      extraGroups =
        [
          "wheel"
          "video"
          "audio"
          "realtime"
        ]
        ++ pkgs.lib.optional config.virtualisation.libvirtd.enable "libvirtd"
        ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager";
    };
  };
}
