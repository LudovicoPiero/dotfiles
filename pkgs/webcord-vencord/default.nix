{
  webcord,
  substituteAll,
  lib,
  vencord-web-extension,
  electron_26,
}: let
  electron = electron_26;
in
  (webcord.overrideAttrs (old: {
    pname = "webcord-vencord";

    patches =
      (old.patches or [])
      ++ [
        (substituteAll {
          src = ./add-extension.patch;
          vencord = vencord-web-extension;
        })
      ];

    meta = with lib;
      old.meta
      // {
        description = "Webcord with Vencord web extension";
        maintainers = with maintainers; [FlafyDev NotAShelf];
      };
  }))
  .override {
    /*
    Latest Webcord update changed to downgrade Electron to version 25,
    which unfortunately resulted in a segfault when launching Webcord-Vencord on Wayland.
    Therefore, we decided to revert the downgrade for now.
    It's possible that this issue will be resolved in Electron version 27
    */
    electron_25 = electron;
  }
