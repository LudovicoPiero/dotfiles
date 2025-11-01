{ lib, config, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.vars = {
    email = mkOption {
      type = types.str;
      default = "email@69420blaze.it";
    };

    username = mkOption {
      type = types.str;
      default = "airi";
    };

    homeDirectory = mkOption {
      type = types.str;
      default = "/home/${config.vars.username}";
    };

    terminal = mkOption {
      type = types.str;
      default = "wezterm";
    };

    stateVersion = mkOption {
      type = types.str;
      default = "24.11";
    };

    timezone = mkOption {
      type = types.str;
      default = "Asia/Tokyo";
    };

    opacity = mkOption {
      type = types.float;
      default = 1.0;
    };

    withGui = mkOption {
      type = types.bool;
      default = false;
    };

    isALaptop = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
