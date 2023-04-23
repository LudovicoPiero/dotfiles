{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: {
  imports = [];

  home = {
    packages = lib.attrValues {
      #TODO: separate firefox
      inherit (pkgs) firefox neofetch ripgrep nitch;
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
