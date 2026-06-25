{
  config,
  lib,
  pkgs,
  inputs',
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkOption
    types
    mkIf
    ;
  cfg = config.mine.mango;
  c = config.mine.theme.colors;
in
{
  options.mine.mango = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable mango configuration.";
    };

    package = mkOption {
      type = types.package;
      default = inputs'.mangowm.packages.mango;
      description = "The mango package to install.";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sessionPackages = [ cfg.package ];
    security.pam.services.swaylock.text = "auth include login";

    hj = {
      packages = [
        cfg.package
        pkgs.swaylock
        pkgs.swayidle
      ];

      xdg.config.files."mango/config.conf".text = ''
        # Autostart
        exec-once=${getExe pkgs.wlr-randr} --output eDP-1 --off
        exec-once=${getExe pkgs.mako}
        exec-once=${getExe pkgs.swayidle} -w timeout 300 '${getExe pkgs.swaylock} -f --color 000000' timeout 600 '${getExe' cfg.package "mmsg"} -s -d toggle_monitor,HDMI-A-1' resume '${getExe' cfg.package "mmsg"} -s -d toggle_monitor,HDMI-A-1' before-sleep '${getExe pkgs.swaylock} -f --color 000000'
        exec-once=${getExe pkgs.thunderbird}
        exec-once=${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store
        exec-once=${getExe' pkgs.wl-clipboard "wl-paste"} --type image --type text --watch ${getExe pkgs.cliphist} store
        exec-once=${getExe pkgs.waybar}
        exec-once=${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png
        exec-once=${getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

        # Monitor
        monitorrule=name:^HDMI-A-1$,width:1920,height:1080,refresh:144,x:0,y:0

        # Keyboard and Input
        repeat_rate=30
        repeat_delay=300
        xkb_rules_layout=us

        # Miscellaneous
        syncobj_enable=1
        xwayland_persistence=1

        # Cursor management
        cursor_hide_timeout=5

        # Snapping and window drag
        enable_floating_snap=1
        snap_distance=20
        drag_corner=4

        # Trackpad
        disable_trackpad=0
        tap_to_click=1
        tap_and_drag=1
        drag_lock=1
        trackpad_natural_scrolling=1
        disable_while_typing=1
        middle_button_emulation=1

        # Window and Focus Behavior
        sloppyfocus=1
        warpcursor=1
        focus_on_activate=1

        # Borders and Gaps
        border_radius=0
        borderpx=2
        gappih=0
        gappiv=0
        gappoh=0
        gappov=0
        smartgaps=1
        no_border_when_single=0

        # Colors
        rootcolor=${c.base00}ff
        bordercolor=${c.base01}ff
        focuscolor=${c.base0E}ff
        urgentcolor=${c.base08}ff
        maximizescreencolor=${c.base0D}ff
        scratchpadcolor=${c.base05}ff
        globalcolor=${c.base0E}ff
        overlaycolor=${c.base0D}ff
        splitcolor=${c.base0E}ff

        # Key Bindings
        bind=SUPER,p,spawn,${getExe pkgs.fuzzel}
        bind=SUPER,Return,spawn,${getExe pkgs.wezterm}
        bind=SUPER,x,spawn,${getExe pkgs.wleave}
        bind=SUPER,w,killclient
        bind=SUPER,f,togglefullscreen
        bind=SUPER+SHIFT,c,reload_config
        bind=SUPER,space,togglefloating
        bindl=SUPER,Escape,spawn,${getExe pkgs.swaylock} -f

        # Workspace
        bind=SUPER,1,view,1
        bind=SUPER,2,view,2
        bind=SUPER,3,view,3
        bind=SUPER,4,view,4
        bind=SUPER,5,view,5

        # Move container to workspace
        bind=SUPER+SHIFT,1,tag,1
        bind=SUPER+SHIFT,2,tag,2
        bind=SUPER+SHIFT,3,tag,3
        bind=SUPER+SHIFT,4,tag,4
        bind=SUPER+SHIFT,5,tag,5

        # Focus direction
        bind=SUPER,h,focusdir,left
        bind=SUPER,j,focusdir,down
        bind=SUPER,k,focusdir,up
        bind=SUPER,l,focusdir,right

        # Move direction
        bind=SUPER+SHIFT,h,exchange_client,left
        bind=SUPER+SHIFT,j,exchange_client,down
        bind=SUPER+SHIFT,k,exchange_client,up
        bind=SUPER+SHIFT,l,exchange_client,right

        # Scratchpad
        bind=SUPER,minus,toggle_scratchpad
        bind=SUPER,q,toggle_scratchpad
        bind=SUPER+SHIFT,minus,minimized
        bind=SUPER+SHIFT,q,minimized

        # Volume and Brightness
        bindl=NONE,XF86AudioLowerVolume,spawn,${getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ -5%
        bindl=NONE,XF86AudioRaiseVolume,spawn,${getExe' pkgs.pulseaudio "pactl"} set-sink-volume @DEFAULT_SINK@ +5%
        bindl=NONE,XF86AudioMute,spawn,${getExe' pkgs.pulseaudio "pactl"} set-sink-mute @DEFAULT_SINK@ toggle
        bindl=NONE,XF86AudioPlay,spawn,${getExe pkgs.playerctl} play-pause
        bindl=NONE,XF86AudioNext,spawn,${getExe pkgs.playerctl} next
        bindl=NONE,XF86AudioPrev,spawn,${getExe pkgs.playerctl} previous
        bindl=NONE,XF86AudioMicMute,spawn,pactl set-source-mute @DEFAULT_SOURCE@ toggle
        bindl=NONE,XF86MonBrightnessDown,spawn,${getExe pkgs.brightnessctl} set 5%-
        bindl=NONE,XF86MonBrightnessUp,spawn,${getExe pkgs.brightnessctl} set 5%+

        # Screenshots
        bind=NONE,Print,spawn_shell,${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - | ${getExe' pkgs.wl-clipboard "wl-copy"}
        bind=SUPER,Print,spawn_shell,${getExe pkgs.grim} - | ${getExe' pkgs.wl-clipboard "wl-copy"}
        bind=SUPER+SHIFT,p,spawn_shell,${getExe pkgs.cliphist} list | ${getExe pkgs.fuzzel} --dmenu | ${getExe pkgs.cliphist} decode | ${getExe' pkgs.wl-clipboard "wl-copy"}

        # Window rules
        # Tag 1: Gaming / Wine
        windowrule=tags:1,appid:^Albion Online Launcher$
        windowrule=tags:1,appid:^Albion-Online$
        windowrule=tags:1,appid:^steam$
        windowrule=tags:1,title:^Sign in to Steam$

        # Steam floating / silent
        windowrule=isfloating:1,appid:^steam$,title:^Special Offers$
        windowrule=isfloating:1,isopensilent:1,appid:^steam$,title:^Steam - News$
        windowrule=isopensilent:1,appid:^steam$,title:(?i)^notificationtoasts
        windowrule=isopensilent:1,appid:^steam$,title:^$

        # Tag 2: Browsers
        windowrule=tags:2,appid:(?i)^(firefox|firefox-esr|floorp|zen|zen-beta|zen-browser|brave-browser|chromium-browser|google-chrome|chrome)$
        # YouTube — idle inhibit on focus
        windowrule=idleinhibit_when_focus:1,appid:(?i)^(firefox|firefox-esr|floorp|zen|zen-beta|zen-browser|brave-browser|chromium-browser|google-chrome|chrome)$,title:(?i)youtube

        # Tag 3: Discord variants / Vesktop
        windowrule=tags:3,title:(?i).*(disc|armc|webc)ord.*
        windowrule=tags:3,appid:^vesktop$

        # Tag 4: Telegram
        windowrule=tags:4,appid:^org\.telegram\.desktop$
        windowrule=tags:4,appid:^telegram-desktop$
        windowrule=isfloating:1,appid:^org\.telegram\.desktop$,title:^Media viewer$
        windowrule=isfloating:1,appid:^telegram-desktop$,title:^Media viewer$

        # Tag 4: Torrent / Media
        windowrule=tags:4,appid:(?i)^(qbittorrent|org\.qbittorrent\.qbittorrent)$
        windowrule=tags:4,appid:^spotify$
        windowrule=tags:4,appid:^org\.fooyin\.fooyin$
        windowrule=tags:4,appid:^tidal-hifi$

        # Tag 5: Thunderbird
        windowrule=tags:5,appid:(?i)^(thunderbird|org\.mozilla\.thunderbird|net\.thunderbird\.Thunderbird)$

        # Bitwarden popup — floating + sticky (MangoWM floats are centered by default)
        windowrule=isfloating:1,isglobal:1,title:(?i).*bitwarden password manager.*
        # Generic notificationtoasts — silent open
        windowrule=isopensilent:1,title:(?i)^notificationtoasts
      '';
    };
  };
}
