self: super: {
  xorg = super.xorg.overrideScope (xself: xsuper: {
    libxcvt = xsuper.libxcvt.overrideAttrs (oldAttrs: {
      src = super.fetchurl {
        url = "mirror://xorg/individual/lib/libxcvt-0.1.2.tar.xz";
        sha256 = "0f6vf47lay9y288n8yg9ckjgz5ypn2hnp03ipp7javkr8h2njq85";
      };
    });
  });
}
