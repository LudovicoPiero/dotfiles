{ lib, config, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.mine.vars = {
    email = mkOption {
      type = types.str;
      default = "email@69420blaze.it";
    };

    name = mkOption {
      type = types.str;
      default = "Ludovico Piero";
    };

    username = mkOption {
      type = types.str;
      default = "airi";
    };

    signingKey = mkOption {
      type = types.str;
      default = "";
      description = "GPG Signing Key ID";
    };

    homeDirectory = mkOption {
      type = types.str;
      default = "/home/${config.mine.vars.username}";
    };

    terminal = mkOption {
      type = types.str;
      default = "alacritty";
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
