{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.mozilla;

  defaultPaths = [
    # Link a .keep file to keep the directory around
    (pkgs.writeTextDir "lib/mozilla/native-messaging-hosts/.keep" "")
  ];

  firefoxNativeMessagingHostsPath =
    if isDarwin then
      "Library/Application Support/Mozilla/NativeMessagingHosts"
    else
      ".mozilla/native-messaging-hosts";
in
{
  options.mozilla = {
    firefoxNativeMessagingHosts = lib.mkOption {
      internal = true;
      type = with lib.types; listOf package;
      default = [ ];
      description = ''
        List of Firefox native messaging hosts to configure.
      '';
    };
  };

  config = lib.mkIf (cfg.firefoxNativeMessagingHosts != [ ]) {
    hj.files =
      if isDarwin then
        let
          firefoxNativeMessagingHostsJoined = pkgs.symlinkJoin {
            name = "ff-native-messaging-hosts";
            paths = defaultPaths ++ cfg.firefoxNativeMessagingHosts;
          };
        in
        {

          "${firefoxNativeMessagingHostsPath}" = lib.mkIf (cfg.firefoxNativeMessagingHosts != [ ]) {
            source = "${firefoxNativeMessagingHostsJoined}/lib/mozilla/native-messaging-hosts";
          };
        }
      else
        let
          nativeMessagingHostsJoined = pkgs.symlinkJoin {
            name = "mozilla-native-messaging-hosts";
            paths = defaultPaths ++ cfg.firefoxNativeMessagingHosts;
          };
        in
        {
          "${firefoxNativeMessagingHostsPath}" = {
            source = "${nativeMessagingHostsJoined}/lib/mozilla/native-messaging-hosts";
          };
        };
  };
}
