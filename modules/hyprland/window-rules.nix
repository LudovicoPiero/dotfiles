{ lib, config, ... }:
let
  inherit (lib) mkIf mkAfter;

  cfgmine = config.mine;
in
mkIf cfgmine.hyprland.enable {
  hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
    # layout & workspace
    # remove borders and rounding when single window
    windowrule = border_size 0, rounding 0, match:float 0, match:workspace w[tv1]s[false]
    windowrule = border_size 0, rounding 0, match:float 0, match:workspace f[1]s[false]
    windowrule = rounding 5, match:workspace s[true]

    # suppress maximize event globally
    windowrule = suppress_event maximize, match:class .*

    # ignore xwayland ghost windows
    windowrule = no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0

    # browsers
    # shared config for all browsers
    windowrule {
        match:class = ^(brave-browser|firefox|floorp|zen-beta|Chromium-browser|chromium-browser)$

        workspace = 2
        no_blur = on
        no_shadow = on
    }

    # inhibit idle when watching videos
    windowrule = idle_inhibit focus, match:class ^(firefox|floorp|zen-beta)$, match:title ^(.*YouTube.*)$
    windowrule = idle_inhibit fullscreen, match:class ^(firefox|floorp|zen-beta)$

    # chat apps
    windowrule = workspace 9, match:class ^(thunderbird)$
    windowrule = workspace 8, match:class ^(whatsapp-for-linux)$

    # discord & variants
    windowrule = workspace 3, match:title ^(.*(Disc|ArmC|WebC)ord.*)$
    windowrule = workspace 3, match:class ^(vesktop)$
    windowrule = no_blur on, no_shadow on, match:title ^(.*(Disc|WebC)ord.*)$

    # telegram
    windowrule {
        match:class = ^(org.telegram.desktop)$

        workspace = 4
        no_anim = on
    }
    windowrule = float, match:title ^(Media viewer)$, match:class ^(org.telegram.desktop)$

    # media
    windowrule = workspace 5, match:class ^(spotify)$, match:title ^(Spotify( (Premium|Free))?)$
    windowrule = workspace 5, match:class (org.fooyin.fooyin)
    windowrule = workspace 5, match:class (tidal-hifi)

    # foobar2000
    windowrule {
        match:class = ^(foobar2000.exe)$

        workspace = 5
        tile = on
        no_anim = on
    }

    # pirate
    windowrule = workspace 7, match:class ^(qBittorrent|org.qbittorrent.qBittorrent)$

    # jetbrains
    windowrule {
        match:class = ^(jetbrains-.*)$

        workspace = 1
        no_blur = on
        no_anim = on
    }

    # keepassxc
    windowrule = no_blur on, no_anim on, match:class ^(org.keepassxc.KeePassXC)$
    windowrule = float, match:class ^(org.keepassxc.KeePassXC)$, match:title ^(Generate Password)$
    windowrule = float, match:class ^(org.keepassxc.KeePassXC)$, match:title ^(KeePassXC - Browser Access Request)$

    # system extensions
    windowrule = float, match:title ^(Extension: (Bitwarden Password Manager))
    windowrule = no_anim on, match:class ^(wleave)$

    # xdg portal
    windowrule {
        match:class = ^(xdg-desktop-portal-gtk)$

        float = on
        no_anim = on
    }

    # steam
    windowrule = workspace 6, match:class ^(steam)$
    windowrule = workspace 6, match:title ^(Sign in to Steam)$

    # steam popups
    windowrule = float, match:class ^(steam)$, match:title ^(Special Offers)$
    windowrule = float, match:class ^(steam)$, match:title ^(Steam - News)$
    windowrule = no_focus on, match:class ^(steam)$, match:title ^(Steam - News)$

    # steam notifications
    windowrule = no_focus on, match:class ^(steam)$, match:title ^(notificationtoasts_.*_desktop)$
    windowrule = no_initial_focus on, match:class ^(steam)$, match:title (^notificationtoasts.*)
    windowrule = no_focus on, match:title (^notificationtoasts.*)
    windowrule = no_focus on, match:class ^(steam)$, match:title ^()$
  '';
}
