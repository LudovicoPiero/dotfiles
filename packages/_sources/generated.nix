# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  catppuccin-fcitx5 = {
    pname = "catppuccin-fcitx5";
    version = "3471b918d4b5aab2d3c3dd9f2c3b9c18fb470e8e";
    src = fetchgit {
      url = "https://github.com/catppuccin/fcitx5";
      rev = "3471b918d4b5aab2d3c3dd9f2c3b9c18fb470e8e";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-1IqFVTEY6z8yNjpi5C+wahMN1kpt0OJATy5echjPXmc=";
    };
    date = "2024-09-01";
  };
  firefox-gnome-theme = {
    pname = "firefox-gnome-theme";
    version = "072ee5d3e8b6f575a31cc294054537dc841d5049";
    src = fetchgit {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme";
      rev = "072ee5d3e8b6f575a31cc294054537dc841d5049";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-8EQS6zY47hVa3jWG9d2MuHK+1JmG/6vdp8gEd2eKFow=";
    };
    date = "2025-03-16";
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
  waybar = {
    pname = "waybar";
    version = "0.12.0";
    src = fetchFromGitHub {
      owner = "alexays";
      repo = "waybar";
      rev = "0.12.0";
      fetchSubmodules = false;
      sha256 = "sha256-VpT3ePqmo75Ni6/02KFGV6ltnpiV70/ovG/p1f2wKkU=";
    };
  };
  wezterm = {
    pname = "wezterm";
    version = "d0ff5cb892c9b49d6a8d76162bebb8d8c229b3cc";
    src = fetchgit {
      url = "https://github.com/wez/wezterm";
      rev = "d0ff5cb892c9b49d6a8d76162bebb8d8c229b3cc";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-An9tJmUaaFM6haFi5amCqfgmGPDqb4Q5xyuW9Uzp/cQ=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./wezterm-d0ff5cb892c9b49d6a8d76162bebb8d8c229b3cc/Cargo.lock;
      outputHashes = {
        "xcb-imdkit-0.3.0" = "sha256-77KaJO+QJWy3tJ9AF1TXKaQHpoVOfGIRqteyqpQaSWo=";
      };
    };
    date = "2025-03-19";
  };
  whitesur-gtk-theme = {
    pname = "whitesur-gtk-theme";
    version = "c20f9cf7e7c09c0d2e54f7659e4cd57c88ba5ef7";
    src = fetchgit {
      url = "https://github.com/vinceliuice/WhiteSur-gtk-theme";
      rev = "c20f9cf7e7c09c0d2e54f7659e4cd57c88ba5ef7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [ ];
      sha256 = "sha256-SWF77YqrijjXlr3r/EccrEyVBxqCOn6tXIHuRA5ngEY=";
    };
    date = "2025-03-20";
  };
}
