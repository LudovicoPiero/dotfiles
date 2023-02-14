{
  config,
  pkgs,
  inputs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = with inputs.nix-gaming.packages.${pkgs.system};
      [
        roblox-player
      ]
      ++ (with pkgs; [
        gamescope
        gamemode
        steam
        inputs.self.packages.${pkgs.system}.TLauncher
      ]);
  };
}
