channels: _final: _prev: {
  __dontExport = true; # overrides clutter up actual creations

  inherit
    (channels.stable)
    cachix
    exa
    ;

  inherit
    (channels.master)
    swayfx
    linuxPackages_xanmod_latest
    ;
}
