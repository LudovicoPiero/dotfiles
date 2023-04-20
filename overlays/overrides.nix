channels: _final: _prev: {
  __dontExport = true; # overrides clutter up actual creations

  inherit
    (channels.stable)
    cachix
    ;

  inherit
    (channels.master)
    swayfx
    ;
}
