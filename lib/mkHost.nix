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
    sharedModules = import ../modules;

    specialArgs = {
      inherit
        inputs
        inputs'
        self'
        lib
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
