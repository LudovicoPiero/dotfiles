_:
let
  browsers = "(?i)(firefox|firefox-esr|floorp|zen|zen-beta|zen-browser|brave-browser|chromium-browser|google-chrome|chrome)";
in
{
  hm.wayland.windowManager.sway.config = {
    # Typography
    fonts = {
      names = [ "JetBrains Mono" ];
      size = 10.0;
    };

    # Gaps Structure
    gaps = {
      inner = 0;
      outer = 0;
      smartGaps = true;
      smartBorders = "on";
    };

    # Window Criteria Assignments
    window.commands = [
      # Xwayland & Wayland Native Browser Marking
      {
        criteria = {
          class = "Chromium-browser";
        };
        command = "mark Browser";
      }
      {
        criteria = {
          class = "Brave-browser";
        };
        command = "mark Browser";
      }
      {
        criteria = {
          class = "firefox";
        };
        command = "mark Browser";
      }
      {
        criteria = {
          app_id = "Chromium-browser";
        };
        command = "mark Browser";
      }
      {
        criteria = {
          app_id = "brave-browser";
        };
        command = "mark Browser";
      }
      {
        criteria = {
          app_id = "firefox";
        };
        command = "mark Browser";
      }

      # Idling Controls
      {
        criteria = {
          con_mark = "Browser";
        };
        command = "inhibit_idle fullscreen";
      }

      # Shared Screens & Indicators
      {
        criteria = {
          app_id = "firefox";
          title = "Firefox — Sharing Indicator";
        };
        command = "floating enable";
      }

      # Games / Wine (Workspace 1)
      {
        criteria = {
          class = "(?i)^jetbrains-";
        };
        command = "move to workspace number 1";
      }
      {
        criteria = {
          class = "^Albion Online Launcher$";
        };
        command = "move to workspace number 1";
      }
      {
        criteria = {
          class = "^Albion-Online$";
        };
        command = "move to workspace number 1";
      }
      {
        criteria = {
          class = "^steam$";
        };
        command = "move to workspace number 1";
      }
      {
        criteria = {
          title = "^Sign in to Steam$";
        };
        command = "move to workspace number 1";
      }
      {
        criteria = {
          class = "^steam$";
          title = "^Special Offers$";
        };
        command = "floating enable";
      }
      {
        criteria = {
          class = "^steam$";
          title = "^Steam - News$";
        };
        command = "floating enable, focus disable";
      }
      {
        criteria = {
          class = "^steam$";
          title = "(?i)^notificationtoasts";
        };
        command = "focus disable";
      }
      {
        criteria = {
          class = "^steam$";
          title = "^$";
        };
        command = "focus disable";
      }
      {
        criteria = {
          class = "^foobar2000.exe$";
        };
        command = "move to workspace number 1, floating disable";
      }

      # Browsers Layout (Workspace 2)
      {
        criteria = {
          app_id = browsers;
        };
        command = "move to workspace number 2";
      }
      {
        criteria = {
          class = browsers;
        };
        command = "move to workspace number 2";
      }
      {
        criteria = {
          app_id = browsers;
          title = "(?i)youtube";
        };
        command = "inhibit_idle focus";
      }
      {
        criteria = {
          class = browsers;
          title = "(?i)youtube";
        };
        command = "inhibit_idle focus";
      }
      {
        criteria = {
          app_id = browsers;
        };
        command = "inhibit_idle fullscreen";
      }
      {
        criteria = {
          class = browsers;
        };
        command = "inhibit_idle fullscreen";
      }

      # Communication Services (Workspace 3)
      {
        criteria = {
          title = "(?i).*(disc|armc|webc)ord.*";
        };
        command = "move to workspace number 3";
      }
      {
        criteria = {
          app_id = "^vesktop$";
        };
        command = "move to workspace number 3";
      }
      {
        criteria = {
          class = "^vesktop$";
        };
        command = "move to workspace number 3";
      }

      # Chat Applications (Workspace 4)
      {
        criteria = {
          app_id = "^org.telegram.desktop$";
        };
        command = "move to workspace number 4";
      }
      {
        criteria = {
          class = "^telegram-desktop$";
        };
        command = "move to workspace number 4";
      }
      {
        criteria = {
          app_id = "^org.telegram.desktop$";
          title = "^Media viewer$";
        };
        command = "floating enable";
      }
      {
        criteria = {
          class = "^telegram-desktop$";
          title = "^Media viewer$";
        };
        command = "floating enable";
      }

      # Mail Delivery (Workspace 5)
      {
        criteria = {
          app_id = "(?i)^(thunderbird|org.mozilla.thunderbird|net.thunderbird.Thunderbird)$";
        };
        command = "move to workspace number 5";
      }
      {
        criteria = {
          class = "(?i)^(thunderbird|org.mozilla.thunderbird|net.thunderbird.Thunderbird)$";
        };
        command = "move to workspace number 5";
      }

      # Torrent Managers (Workspace 7)
      {
        criteria = {
          app_id = "(?i)^(qbittorrent|org.qbittorrent.qbittorrent)$";
        };
        command = "move to workspace number 7";
      }
      {
        criteria = {
          class = "(?i)^(qbittorrent|org.qbittorrent.qbittorrent)$";
        };
        command = "move to workspace number 7";
      }

      # Instant Messaging (Workspace 8)
      {
        criteria = {
          app_id = "^whatsapp-for-linux$";
        };
        command = "move to workspace number 8";
      }
      {
        criteria = {
          class = "^whatsapp-for-linux$";
        };
        command = "move to workspace number 8";
      }

      # Music / Audio Layer (Workspace 9)
      {
        criteria = {
          app_id = "^spotify$";
        };
        command = "move to workspace number 9";
      }
      {
        criteria = {
          class = "^spotify$";
        };
        command = "move to workspace number 9";
      }
      {
        criteria = {
          app_id = "^org.fooyin.fooyin$";
        };
        command = "move to workspace number 9";
      }
      {
        criteria = {
          class = "^org.fooyin.fooyin$";
        };
        command = "move to workspace number 9";
      }
      {
        criteria = {
          app_id = "^tidal-hifi$";
        };
        command = "move to workspace number 9";
      }
      {
        criteria = {
          class = "^tidal-hifi$";
        };
        command = "move to workspace number 9";
      }

      # Security & Utilities Overlay
      {
        criteria = {
          title = "(?i).*bitwarden password manager.*";
        };
        command = "floating enable, move position center, sticky enable";
      }
      {
        criteria = {
          title = "(?i)^notificationtoasts";
        };
        command = "focus disable";
      }
      {
        criteria = {
          app_id = "^xdg-desktop-portal-gtk$";
        };
        command = "floating enable";
      }
      {
        criteria = {
          class = "^xdg-desktop-portal-gtk$";
        };
        command = "floating enable";
      }

      # Credentials Managers
      {
        criteria = {
          app_id = "^org.keepassxc.KeePassXC$";
          title = "^Generate Password$";
        };
        command = "floating enable";
      }
      {
        criteria = {
          class = "^org.keepassxc.KeePassXC$";
          title = "^Generate Password$";
        };
        command = "floating enable";
      }
      {
        criteria = {
          app_id = "^org.keepassxc.KeePassXC$";
          title = "(?i).*browser access request.*";
        };
        command = "floating enable";
      }
      {
        criteria = {
          class = "^org.keepassxc.KeePassXC$";
          title = "(?i).*browser access request.*";
        };
        command = "floating enable";
      }
    ];
  };
}
