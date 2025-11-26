{ lib, config, ... }:
let
  inherit (lib) mkAfter mkIf;

  cfgmine = config.mine;
in
mkIf cfgmine.mangowc.enable {
  hj.xdg.config.files."mango/config.conf".text = mkAfter ''
    # Monitor rules
    monitorrule=HDMI-A-1,0.55,1,tile,0,1,0,0,1920,1080,180
    monitorrule=eDP-1,0.55,1,tile,0,1,1920,0,1366,768,60

    # layout support:
    # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
    tagrule=id:1,layout_name:tile
    tagrule=id:2,layout_name:tile
    tagrule=id:3,layout_name:tile
    tagrule=id:4,layout_name:tile
    tagrule=id:5,layout_name:tile
    tagrule=id:6,layout_name:tile
    tagrule=id:7,layout_name:tile
    tagrule=id:8,layout_name:tile
    tagrule=id:9,layout_name:tile

    # Window Rules
    # Email & Chat
    windowrule=tags:9,isopensilent:1,appid:^(thunderbird)$
    windowrule=tags:8,appid:^(whatsapp-for-linux)$
    windowrule=tags:7,appid:^(qBittorrent|org.qbittorrent.qBittorrent)$
    windowrule=tags:4,appid:^(org.telegram.desktop)$
    windowrule=tags:3,title:^(.*(Disc|ArmC|WebC)ord.*)$
    windowrule=tags:3,appid:^(vesktop)$

    # Steam & Games
    windowrule=tags:6,appid:^(steam)$
    windowrule=tags:6,title:^(Sign in to Steam)$
    windowrule=isfloating:1,appid:^(steam)$,title:^(Special Offers)$
    windowrule=isfloating:1,appid:^(steam)$,title:^(Steam - News)$
    windowrule=isopensilent:1,appid:^(steam)$,title:^(Steam - News)$
    windowrule=isopensilent:1,appid:^(steam)$,title:^(notificationtoasts_.*_desktop)$
    windowrule=isopensilent:1,appid:^(steam)$,title:(^notificationtoasts.*)
    windowrule=isopensilent:1,appid:^(steam)$,title:^()$
    windowrule=tags:1,appid:^(Albion-Online)$

    # Music & Media
    windowrule=tags:5,appid:^(spotify)$,title:^(Spotify( (Premium|Free))?)$
    windowrule=tags:5,appid:(org.fooyin.fooyin)
    windowrule=tags:5,appid:(tidal-hifi)
    windowrule=tags:5,appid:^(foobar2000.exe)$
    windowrule=force_tile_state:1,appid:^(foobar2000.exe)$
    windowrule=isnoanimation:1,appid:^(foobar2000.exe)$

    # Browsers
    windowrule=tags:2,appid:^(firefox|floorp|zen-beta)$
    windowrule=noblur:1,appid:^(firefox|floorp|zen-beta)$
    windowrule=isnoshadow:1,appid:^(firefox|floorp|zen-beta)$
    windowrule=tags:2,appid:^(floorp)$
    windowrule=noblur:1,appid:^(floorp)$
    windowrule=isnoshadow:1,appid:^(floorp)$
    windowrule=tags:2,appid:^(Chromium-browser)$
    windowrule=tags:2,appid:^(chromium-browser)$
    windowrule=noblur:1,appid:^(Chromium-browser)$
    windowrule=noblur:1,appid:^(chromium-browser)$
    windowrule=isnoshadow:1,appid:^(Chromium-browser)$
    windowrule=isnoshadow:1,appid:^(chromium-browser)$

    # Development & Tools
    windowrule=tags:1,appid:^(jetbrains-.*)$
    windowrule=noblur:1,appid:^(jetbrains-.*)$
    windowrule=isnoanimation:1,appid:^(jetbrains-.*)$
    windowrule=noblur:1,appid:^(org.keepassxc.KeePassXC)$
    windowrule=isnoanimation:1,appid:^(org.keepassxc.KeePassXC)$
    windowrule=isfloating:1,appid:^(org.keepassxc.KeePassXC)$,title:^(Generate Password)$
    windowrule=isfloating:1,appid:^(org.keepassxc.KeePassXC)$,title:^(KeePassXC - Browser Access Request)$
    windowrule=isfloating:1,title:^(Extension: (Bitwarden Password Manager))

    # Floating & UI Elements
    windowrule=isfloating:1,appid:^(org.telegram.desktop)$,title:^(Media viewer)$
    windowrule=isopensilent:1,title:(^notificationtoasts.*)
    windowrule=noblur:1,title:^(.*(Disc|WebC)ord.*)$
    windowrule=noblur:1,appid:^(xdg-desktop-portal-gtk)$
    windowrule=isnoshadow:1,title:^(.*(Disc|WebC)ord.*)$
    windowrule=isfloating:1,appid:^(xdg-desktop-portal-gtk)$
    windowrule=isnoanimation:1,appid:^(org.telegram.desktop)$
    windowrule=isnoanimation:1,appid:^(wleave)$

    # General
    windowrule=ignore_maximize:1,appid:.*
  '';
}
