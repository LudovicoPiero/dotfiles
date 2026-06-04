{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkFirefoxModule = import ../_mkFirefoxModule.nix;
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
    configPath = ".mozilla/firefox";
  };
})
  # HACKS:
  { inherit config lib pkgs; }
