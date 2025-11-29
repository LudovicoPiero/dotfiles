{ lib, config, ... }:
let
  inherit (lib) mkIf mkAfter;

  cfgmine = config.mine;
in
mkIf cfgmine.hyprland.enable {
  hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
    windowrule = bordersize 0, floating:0, onworkspace:w[tv1]s[false]
    windowrule = rounding 0, floating:0, onworkspace:w[tv1]s[false]
    windowrule = bordersize 0, floating:0, onworkspace:f[1]s[false]
    windowrule = rounding 0, floating:0, onworkspace:f[1]s[false]
    windowrule = rounding 5, onworkspace:s[true]
    windowrule = workspace 9, class:^(thunderbird)$
    windowrule = workspace 8, class:^(whatsapp-for-linux)$
    windowrule = workspace 7, class:^(qBittorrent|org.qbittorrent.qBittorrent)$
    windowrule = suppressevent maximize, class:.*
    windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    windowrule = float, title:^(Extension: (Bitwarden Password Manager))
    windowrule = float, title:^(Media viewer)$, class:^(org.telegram.desktop)$
    windowrule = workspace 6, class:^(steam)$
    windowrule = workspace 6, title:^(Sign in to Steam)$
    windowrule = float, class:^(steam)$,title:^(Special Offers)$
    windowrule = float, class:^(steam)$,title:^(Steam - News)$
    windowrule = nofocus, class:^(steam)$,title:^(Steam - News)$
    windowrule = nofocus, class:^(steam)$,title:^(notificationtoasts_.*_desktop)$
    windowrule = noinitialfocus, class:^(steam)$, title:(^notificationtoasts.*)
    windowrule = nofocus, title:(^notificationtoasts.*)
    windowrule = nofocus, class:^(steam)$, title:^()$
    windowrule = workspace 5, class:^(spotify)$, title:^(Spotify( (Premium|Free))?)$
    windowrule = workspace 5, class:(org.fooyin.fooyin)
    windowrule = workspace 5, class:(tidal-hifi)
    windowrule = workspace 4, class:^(org.telegram.desktop)$
    windowrule = workspace 3, title:^(.*(Disc|ArmC|WebC)ord.*)$
    windowrule = workspace 3, class:^(vesktop)$
    windowrule = workspace 2, class:^(brave-browser|firefox|floorp|zen-beta|Chromium-browser|chromium-browser)$
    windowrule = noblur, class:^(brave-browser|firefox|floorp|zen-beta|Chromium-browser|chromium-browser)$
    windowrule = noshadow, class:^(brave-browser|firefox|floorp|zen-beta|Chromium-browser|chromium-browser)$
    windowrule = idleinhibit focus, class:^(brave-browser|firefox|floorp|zen-beta|Chromium-browser|chromium-browser)$, title:^(.*YouTube.*)$
    windowrule = idleinhibit fullscreen, class:^(brave-browser|firefox|floorp|zen-beta|Chromium-browser|chromium-browser)$
    windowrule = workspace 5, class:^(foobar2000.exe)$
    windowrule = tile, class:^(foobar2000.exe)$
    windowrule = noanim, class:^(foobar2000.exe)$
    windowrule = workspace 2, class:^(floorp)$
    windowrule = noblur, class:^(floorp)$
    windowrule = noshadow, class:^(floorp)$
    windowrule = workspace 2, class:^(Chromium-browser)$
    windowrule = workspace 2, class:^(chromium-browser)$
    windowrule = noblur, class:^(Chromium-browser)$
    windowrule = noblur, class:^(chromium-browser)$
    windowrule = noshadow, class:^(Chromium-browser)$
    windowrule = noshadow, class:^(chromium-browser)$
    windowrule = workspace 1, class:^(jetbrains-.*)$
    windowrule = noblur, class:^(jetbrains-.*)$
    windowrule = noanim, class:^(jetbrains-.*)$
    windowrule = workspace 1, class:^(Albion-Online)$
    windowrule = noblur, class:^(org.keepassxc.KeePassXC)$
    windowrule = noanim, class:^(org.keepassxc.KeePassXC)$
    windowrule = float, class:^(org.keepassxc.KeePassXC)$,title:^(Generate Password)$
    windowrule = float, class:^(org.keepassxc.KeePassXC)$,title:^(KeePassXC - Browser Access Request)$
    windowrule = noblur, title:^(.*(Disc|WebC)ord.*)$
    windowrule = noblur, class:^(xdg-desktop-portal-gtk)$
    windowrule = noshadow, title:^(.*(Disc|WebC)ord.*)$
    windowrule = float, class:^(xdg-desktop-portal-gtk)$
    windowrule = noanim, class:^(org.telegram.desktop)$
    windowrule = noanim, class:^(wleave)$
  '';
}
