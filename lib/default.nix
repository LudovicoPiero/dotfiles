{lib}:
lib.makeExtensible (_self: rec {
  ## Define your own library functions here!
  #id = x: x;
  ## Or in files, containing functions that take {lib}
  #foo = callLibs ./foo.nix;
  ## In configs, they can be used under "lib.our"
  explodeAttrs = set: map (a: lib.getAttr a set) (lib.attrNames set);
})
