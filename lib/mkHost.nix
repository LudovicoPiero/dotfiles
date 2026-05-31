{
  withSystem,
  inputs,
  lib,
}:

hostDir: hostName:
let
  inherit (builtins) pathExists isAttrs isString;

  systemFile =
    if pathExists (hostDir + "/system.nix") then
      import (hostDir + "/system.nix")
    else
      null;

  system =
    if isAttrs systemFile && systemFile ? system then
      systemFile.system
    else if isString systemFile then
      systemFile
    else
      "x86_64-linux";

  configPath = hostDir + "/configuration.nix";

in
withSystem system (
  { inputs', self', ... }:
  let
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

    pkgs-master = import inputs.nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };

    sharedModules = import ../modules;

    specialArgs = {
      inherit
        inputs
        inputs'
        self'
        lib
        pkgs-stable
        pkgs-master
        ;
    };
  in
  inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs system;
    modules = [
      {
        imports = [
          sharedModules
          configPath
        ];
        networking.hostName = hostName;
      }
    ];
  }
)
