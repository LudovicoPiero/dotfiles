{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkFirefoxModule = import ../_mkFirefoxModule.nix;
  linuxConfigHome = lib.removePrefix "/home/${config.mine.vars.username}/" config.hj.xdg.config.directory;
in
(mkFirefoxModule {
  modulePath = [
    "mine"
    "programs"
    "firefox"
  ];
  name = "Firefox";
  wrappedPackageName = "firefox";
  unwrappedPackageName = "firefox-unwrapped";
  visible = true;

  platforms.linux = {
    # Dynamically targets ~/.config/mozilla/firefox
    configPath = "${linuxConfigHome}/mozilla/firefox";
  };
})
  # HACKS:
  { inherit config lib pkgs; }
