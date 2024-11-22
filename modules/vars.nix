{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.myOptions.vars = {
    colorScheme = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
    };

    email = mkOption {
      type = types.str;
      default = "email@69420blaze.it";
    };

    mainFont = mkOption {
      type = types.str;
      default = "Iosevka q Semibold";
    };

    username = mkOption {
      type = types.str;
      default = "airi";
    };

    terminal = mkOption {
      type = types.str;
      default = "wezterm";
    };

    sshPublicKey = mkOption {
      type = types.str;
      default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtzB1oiuDptWi04PAEJVpSAcvD96AL0S21zHuMgmcE9 ludovico@sforza";
    };

    stateVersion = mkOption {
      type = types.str;
      default = "24.11";
    };

    timezone = mkOption {
      type = types.str;
      default = "Asia/Tokyo";
    };

    withGui = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
