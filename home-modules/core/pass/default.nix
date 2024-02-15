{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.pass;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.mine.pass.enable = mkEnableOption "password-store";

  config = mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      package = pkgs.pass-wayland.withExtensions (exts: [
        exts.pass-update
        exts.pass-import
      ]);
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.configHome}/password-store";
      };
    };
  };
}
