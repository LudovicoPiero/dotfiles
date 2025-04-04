# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  catppuccin-fcitx5 = {
    pname = "catppuccin-fcitx5";
    version = "383c27ac46cbb55aa5f58acbd32841c1ed3a78a0";
    src = fetchgit {
      url = "https://github.com/catppuccin/fcitx5";
      rev = "383c27ac46cbb55aa5f58acbd32841c1ed3a78a0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-n83f9ge4UhBFlgCPRCXygcVJiDp7st48lAJHTm1ohR4=";
    };
    date = "2025-03-22";
  };
  firefox-gnome-theme = {
    pname = "firefox-gnome-theme";
    version = "6cb02d0cb8df67502f2f1daea0b9b1c20df58960";
    src = fetchgit {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme";
      rev = "6cb02d0cb8df67502f2f1daea0b9b1c20df58960";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-zOXxXXJ3Fss28gFc8BWijKd25MesO3ViuRq3CRkI6Wg=";
    };
    date = "2025-03-25";
  };
  macos-hyprcursors = {
    pname = "macos-hyprcursors";
    version = "v1";
    src = fetchFromGitHub {
      owner = "driedpampas";
      repo = "macOS-hyprcursor";
      rev = "v1";
      fetchSubmodules = false;
      sha256 = "sha256-W7Uglem1qcneRFg/eR6D20p+ggkSFwh5QJYfq8OisLk=";
    };
  };
  san-francisco-pro = {
    pname = "san-francisco-pro";
    version = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
    src = fetchgit {
      url = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts";
      rev = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-mAXExj8n8gFHq19HfGy4UOJYKVGPYgarGd/04kUIqX4=";
    };
    date = "2021-06-22";
  };
  whitesur-gtk-theme = {
    pname = "whitesur-gtk-theme";
    version = "8ff1fe69ab822c4c110e51482d9ac046ef8d88b6";
    src = fetchgit {
      url = "https://github.com/vinceliuice/WhiteSur-gtk-theme";
      rev = "8ff1fe69ab822c4c110e51482d9ac046ef8d88b6";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-pfaxW6f6prsRPrUzP1yymnkT1tGcO+QL36gM+5/1M3I=";
    };
    date = "2025-03-28";
  };
}
