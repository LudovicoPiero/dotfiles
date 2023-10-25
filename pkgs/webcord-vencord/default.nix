{
  webcord,
  substituteAll,
  lib,
  vencord-web-extension,
  electron_24,
}:
(webcord.overrideAttrs (old: {
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
  electron_27 = electron_24;
}
