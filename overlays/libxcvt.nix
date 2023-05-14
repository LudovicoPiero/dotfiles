self: super: {
  xorg = super.xorg.overrideScope (xself: xsuper: {
    libxcvt = xsuper.libxcvt.overrideAttrs (oldAttrs: {
      src = super.fetchurl {
        url = "mirror://xorg/individual/lib/libxcvt-0.1.2.tar.xz";
        sha256 = "BWFpBUR5biXPvXGAa6Gw15f/5GTpeWQREj55RQ9x2zg=";
      };
    });
  });
}
