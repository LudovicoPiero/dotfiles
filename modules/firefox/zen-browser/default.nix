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
    "zen-browser"
  ];
  name = "Zen";
  wrappedPackageName = "zen-browser";
  unwrappedPackageName = "zen-browser-unwrapped";
  visible = true;

  platforms.linux = {
    configPath = ".zen";
  };
})
  # HACKS :
  { inherit config lib pkgs; }
