# Got it from fufexan's dotfiles
{
  pkgs,
  config,
  lib,
  ...
}: let
  hmConf = config.home-manager.users."${config.vars.username}";
  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${lib.optionalString (hmConf.home.sessionPath != []) ''
      export PATH=${builtins.concatStringsSep ":" hmConf.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
        export ${k}=${toString v}
      '')
      hmConf.home.sessionVariables)}
    ${hmConf.home.sessionVariablesExtra}
    exec "$@"
  '';

  # runs processes as systemd transient services
  run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --slice=app-manual.slice \
      --property=ExitType=cgroup \
      --user \
      --wait \
      bash -lc "exec ${apply-hm-env} $@"
  '';
in {
  home-manager.users.${config.vars.username} = {
    home.packages = [run-as-service];
  };
}
