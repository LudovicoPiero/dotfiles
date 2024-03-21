{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      neovim
      kitty
      firefox
      vesktop
      wezterm
      element-desktop
      spotify
      vscodium
      nil
      inputs.chaotic.packages.${pkgs.system}.nixfmt_rfc166
    ];

    stateVersion = "23.11";
  };
}
