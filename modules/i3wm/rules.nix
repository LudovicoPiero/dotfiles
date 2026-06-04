{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.mine.i3;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."i3/config.d/rules.conf".text = ''
      for_window [class=".*"] border pixel 2
      for_window [class="^$" title="^$"] floating enable

      assign [class="^(jetbrains-.*)$"] "1"
      assign [class="^(Albion Online Launcher)$"] "1"
      assign [class="^(Albion-Online)$"] "1"

      assign [class="^(zen|zen-beta|zen-browser|brave-browser|Chromium-browser|chromium-browser|google-chrome|chrome)$"] "2"
      assign [class="^(Firefox|firefox|firefox-esr|floorp)$"] "3"

      assign [class="^(org.telegram.desktop)$"] "4"
      assign [title="^(.*(Disc|ArmC|WebC)ord.*)$"] "4"
      assign [class="^(vesktop)$"] "4"
      for_window [class="^(org.telegram.desktop)$" title="^(Media viewer)$"] floating enable

      assign [class="^(thunderbird|org.mozilla.Thunderbird)$"] "5"

      assign [class="^(steam)$"] "6"
      for_window [title="^(Sign in to Steam)$"] move container to workspace "6"
      for_window [class="^(steam)$" title="^(Special Offers)$"] floating enable
      for_window [class="^(steam)$" title="^(Steam - News)$"] floating enable

      assign [class="^(qBittorrent|org.qbittorrent.qBittorrent)$"] "7"
      assign [class="^(whatsapp-for-linux)$"] "8"

      assign [class="^(spotify)$"] "9"
      assign [class="^(org.fooyin.fooyin)$"] "9"
      assign [class="^(tidal-hifi)$"] "9"
      assign [class="^(foobar2000.exe)$"] "9"

      for_window [title="^(.*Bitwarden Password Manager.*)$"] floating enable
      for_window [class="^(xdg-desktop-portal-gtk)$"] floating enable
      for_window [class="^(org.keepassxc.KeePassXC)$" title="^(Generate Password)$"] floating enable
      for_window [class="^(org.keepassxc.KeePassXC)$" title="^(KeePassXC - Browser Access Request)$"] floating enable
    '';
  };
}
