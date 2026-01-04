# lib/default.nix
lib: {
  # Usage: lib.strip "#1a1b26" -> "1a1b26"
  strip = color: lib.substring 1 6 color;
}
