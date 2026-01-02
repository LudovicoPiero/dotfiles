{ config, lib, ... }:
let
  inherit (lib) mkIf mkAfter;
  cfg = config.mine.hyprland;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/hyprland.conf".text = mkAfter ''
      # Workspace Rules
      workspace = w[tv1]s[false], gapsout:0, gapsin:0
      workspace = f[1]s[false], gapsout:0, gapsin:0

      windowrule {
          name = maximize-event
          match:class = .*
          suppress_event = maximize
      }
      windowrule {
          name = ghost-fix
          match:class = ^$
          match:title = ^$
          match:xwayland = 1
          match:float = 1
          match:fullscreen = 0
          match:pin = 0
          no_focus = on
      }

      # Workspace 1: Dev & Games
      windowrule {
          name = jetbrains
          match:class = ^(jetbrains-.*)$
          workspace = 1
          no_blur = on
          no_anim = on
      }
      windowrule {
          name = albion
          match:class = ^(Albion-Online)$
          workspace = 1
      }

      # Workspace 2: Firefox
      $firefox = ^(firefox|firefox-esr|floorp|zen|zen-beta)$
      windowrule {
          name = firefox-main
          match:class = $firefox
          workspace = 2
      }
      windowrule {
          name = firefox-perf
          match:class = $firefox
          no_blur = on
          no_shadow = on
          idle_inhibit = fullscreen
      }
      windowrule {
          name = firefox-video
          match:class = $firefox
          match:title = ^(.*YouTube.*)$
          idle_inhibit = focus
      }

      # Workspace 3: Brave/Chromium
      $chromium = ^(brave-browser|Chromium-browser|chromium-browser|google-chrome|chrome)$
      windowrule {
          name = chromium-main
          match:class = $chromium
          workspace = 3
      }
      windowrule {
          name = chromium-perf
          match:class = $chromium
          no_blur = on
          no_shadow = on
          idle_inhibit = fullscreen
      }
      windowrule {
          name = chromium-video
          match:class = $chromium
          match:title = ^(.*YouTube.*)$
          idle_inhibit = focus
      }

      # Workspace 4: Social (Discord, Vesktop, Telegram)
      windowrule {
          name = telegram
          match:class = ^(org.telegram.desktop)$
          workspace = 4
          no_anim = on
      }
      windowrule {
          name = telegram-viewer
          match:class = ^(org.telegram.desktop)$
          match:title = ^(Media viewer)$
          float = on
      }
      windowrule {
          name = discord-web
          match:title = ^(.*(Disc|ArmC|WebC)ord.*)$
          workspace = 4
          no_blur = on
          no_shadow = on
      }
      windowrule {
          name = vesktop
          match:class = ^(vesktop)$
          workspace = 4
      }

      # Workspace 5: Mail
      windowrule {
          name = mail
          match:class = ^(thunderbird|org.mozilla.Thunderbird)$
          workspace = 5
      }

      # Workspace 6: Steam
      windowrule {
          name = steam-main
          match:class = ^(steam)$
          workspace = 6
      }
      windowrule {
          name = steam-signin
          match:title = ^(Sign in to Steam)$
          workspace = 6
      }
      windowrule {
          name = steam-offers
          match:class = ^(steam)$
          match:title = ^(Special Offers)$
          float = on
      }
      windowrule {
          name = steam-news
          match:class = ^(steam)$
          match:title = ^(Steam - News)$
          float = on
          no_initial_focus = on
      }
      windowrule {
          name = steam-toasts
          match:class = ^(steam)$
          match:title = ^(notificationtoasts_.*_desktop)$
          no_focus = on
      }
      windowrule {
          name = steam-toasts-generic
          match:class = ^(steam)$
          match:title = ^notificationtoasts.*
          no_initial_focus = on
      }
      windowrule {
          name = steam-empty
          match:class = ^(steam)$
          match:title = ^$
          no_focus = on
      }

      # Workspace 7: Torrent
      windowrule {
          name = torrent
          match:class = ^(qBittorrent|org.qbittorrent.qBittorrent)$
          workspace = 7
      }

      # Workspace 8: WhatsApp
      windowrule {
          name = whatsapp
          match:class = ^(whatsapp-for-linux)$
          workspace = 8
      }

      # Workspace 9: Media/Music
      windowrule {
          name = spotify
          match:class = ^(spotify)$
          workspace = 9
      }
      windowrule {
          name = fooyin
          match:class = ^(org.fooyin.fooyin)$
          workspace = 9
      }
      windowrule {
          name = tidal
          match:class = ^(tidal-hifi)$
          workspace = 9
      }
      windowrule {
          name = foobar
          match:class = ^(foobar2000.exe)$
          workspace = 9
          tile = on
          no_anim = on
      }

      # Floating / Misc
      windowrule {
          name = bitwarden
          match:title = ^(Extension: \(Bitwarden Password Manager\))$
          float = on
      }
      windowrule {
          name = toasts
          match:title = ^notificationtoasts.*
          no_focus = on
      }
      windowrule {
          name = portal-gtk
          match:class = ^(xdg-desktop-portal-gtk)$
          float = on
          no_blur = on
      }

      # KeePassXC
      windowrule {
          name = keepass-main
          match:class = ^(org.keepassxc.KeePassXC)$
          no_blur = on
          no_anim = on
      }
      windowrule {
          name = keepass-gen
          match:class = ^(org.keepassxc.KeePassXC)$
          match:title = ^(Generate Password)$
          float = on
      }
      windowrule {
          name = keepass-request
          match:class = ^(org.keepassxc.KeePassXC)$
          match:title = ^(KeePassXC - Browser Access Request)$
          float = on
      }

    '';
  };

}
