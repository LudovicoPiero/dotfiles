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

    # global tweaks
    # ignore maximize requests
    windowrule=ignore_maximize:1,appid:.*

    # browsers
    # main browser group -> tag 2, no blur/shadow
    windowrule=tags:2,noblur:1,isnoshadow:1,appid:^(brave-browser|firefox|floorp|zen-beta|Chromium-browser|chromium-browser)$

    # chat apps
    windowrule=tags:9,isopensilent:1,appid:^(thunderbird)$
    windowrule=tags:8,appid:^(whatsapp-for-linux)$

    # discord/vesktop -> tag 3
    windowrule=tags:3,title:^(.*(Disc|ArmC|WebC)ord.*)$
    windowrule=tags:3,appid:^(vesktop)$
    # remove blur/shadow for discord clients
    windowrule=noblur:1,isnoshadow:1,title:^(.*(Disc|WebC)ord.*)$

    # telegram -> tag 4
    windowrule=tags:4,isnoanimation:1,appid:^(org.telegram.desktop)$
    windowrule=isfloating:1,title:^(Media viewer)$,appid:^(org.telegram.desktop)$

    # media
    # spotify/fooyin/tidal -> tag 5
    windowrule=tags:5,appid:^(spotify)$,title:^(Spotify( (Premium|Free))?)$
    windowrule=tags:5,appid:(org.fooyin.fooyin)
    windowrule=tags:5,appid:(tidal-hifi)

    # foobar2000 -> tag 5, forced tile
    windowrule=tags:5,force_tile_state:1,isnoanimation:1,appid:^(foobar2000.exe)$

    # dev tools
    windowrule=tags:7,appid:^(qBittorrent|org.qbittorrent.qBittorrent)$

    # jetbrains -> tag 1
    windowrule=tags:1,noblur:1,isnoanimation:1,appid:^(jetbrains-.*)$

    # games
    windowrule=tags:1,appid:^(Albion-Online)$

    # keepassxc
    windowrule=noblur:1,isnoanimation:1,appid:^(org.keepassxc.KeePassXC)$
    windowrule=isfloating:1,appid:^(org.keepassxc.KeePassXC)$,title:^(Generate Password)$
    windowrule=isfloating:1,appid:^(org.keepassxc.KeePassXC)$,title:^(KeePassXC - Browser Access Request)$

    # system extensions/tools
    windowrule=isfloating:1,title:^(Extension: (Bitwarden Password Manager))
    windowrule=isnoanimation:1,appid:^(wleave)$

    # xdg portal
    windowrule=isfloating:1,noblur:1,appid:^(xdg-desktop-portal-gtk)$

    # steam -> tag 6
    windowrule=tags:6,appid:^(steam)$
    windowrule=tags:6,title:^(Sign in to Steam)$

    # steam popups
    windowrule=isfloating:1,appid:^(steam)$,title:^(Special Offers)$
    windowrule=isfloating:1,isopensilent:1,appid:^(steam)$,title:^(Steam - News)$

    # steam notifications (attempt to stop focus stealing)
    windowrule=isopensilent:1,appid:^(steam)$,title:^(notificationtoasts_.*_desktop)$
    windowrule=isopensilent:1,appid:^(steam)$,title:(^notificationtoasts.*)
    windowrule=isopensilent:1,title:(^notificationtoasts.*)
  '';
}
