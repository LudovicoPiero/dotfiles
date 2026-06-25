{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.mine.sway;
in
{

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];
      xdg.config.files."sway/window-rules".text = ''
        gaps inner 2
        gaps outer 2
        smart_gaps on
        smart_borders on

        # Browser marks
        for_window [class="Chromium-browser"] mark Browser
        for_window [class="Brave-browser"] mark Browser
        for_window [class="firefox"] mark Browser
        for_window [app_id="Chromium-browser"] mark Browser
        for_window [app_id="brave-browser"] mark Browser
        for_window [app_id="firefox"] mark Browser
        for_window [app_id="firefox-esr"] mark Browser
        for_window [app_id="zen"] mark Browser
        for_window [app_id="zen-beta"] mark Browser
        for_window [app_id="zen-browser"] mark Browser
        for_window [app_id="floorp"] mark Browser
        for_window [app_id="google-chrome"] mark Browser
        for_window [app_id="chrome"] mark Browser

        for_window [con_mark="Browser" title="(?i)youtube"] inhibit_idle focus
        for_window [con_mark="Browser"] inhibit_idle fullscreen
        for_window [app_id="firefox" title="Firefox — Sharing Indicator"] floating enable

        # Workspace 1: Dev / Games
        for_window [class="(?i)^jetbrains-"] move to workspace number 1
        for_window [class="^Albion Online Launcher$"] move to workspace number 1
        for_window [class="^Albion-Online$"] move to workspace number 1
        for_window [class="^steam$"] move to workspace number 1
        for_window [title="^Sign in to Steam$"] move to workspace number 1
        for_window [class="^Steam$" title="^Friends$"] floating enable
        for_window [class="^Steam$" title="Steam - News"] floating enable
        for_window [class="^Steam$" title=".* - Chat"] floating enable
        for_window [class="^Steam$" title="^Settings$"] floating enable
        for_window [class="^Steam$" title=".* - event started"] floating enable
        for_window [class="^Steam$" title=".* CD key"] floating enable
        for_window [class="^Steam$" title="^Steam - Self Updater$"] floating enable
        for_window [class="^Steam$" title="^Screenshot Uploader$"] floating enable
        for_window [class="^Steam$" title="^Steam Guard - Computer Authorization Required$"] floating enable
        for_window [title="^Steam Keyboard$"] floating enable
        for_window [class="^steam$" title="^$"] focus disable
        for_window [class="^foobar2000.exe$"] move to workspace number 1, floating disable

        # Workspace 2: Browsers
        for_window [app_id="firefox"] move to workspace number 2
        for_window [app_id="firefox-esr"] move to workspace number 2
        for_window [app_id="floorp"] move to workspace number 2
        for_window [app_id="zen"] move to workspace number 2
        for_window [app_id="zen-beta"] move to workspace number 2
        for_window [app_id="zen-browser"] move to workspace number 2
        for_window [app_id="brave-browser"] move to workspace number 2
        for_window [app_id="chromium-browser"] move to workspace number 2
        for_window [app_id="google-chrome"] move to workspace number 2
        for_window [app_id="chrome"] move to workspace number 2
        for_window [class="(?i)firefox"] move to workspace number 2
        for_window [class="(?i)firefox-esr"] move to workspace number 2
        for_window [class="(?i)floorp"] move to workspace number 2
        for_window [class="(?i)zen"] move to workspace number 2
        for_window [class="(?i)zen-beta"] move to workspace number 2
        for_window [class="(?i)zen-browser"] move to workspace number 2
        for_window [class="(?i)brave-browser"] move to workspace number 2
        for_window [class="(?i)chromium-browser"] move to workspace number 2
        for_window [class="(?i)google-chrome"] move to workspace number 2
        for_window [class="(?i)chrome"] move to workspace number 2

        # Workspace 3: Chat (Discord/etc)
        for_window [title="(?i).*discord.*"] move to workspace number 3
        for_window [title="(?i).*armcord.*"] move to workspace number 3
        for_window [title="(?i).*webcord.*"] move to workspace number 3
        for_window [app_id="^vesktop$"] move to workspace number 3
        for_window [class="^vesktop$"] move to workspace number 3

        # Workspace 4: Comms / Media
        for_window [app_id="^org.telegram.desktop$"] move to workspace number 4
        for_window [class="^telegram-desktop$"] move to workspace number 4
        for_window [app_id="^org.telegram.desktop$" title="^Media viewer$"] floating enable
        for_window [class="^telegram-desktop$" title="^Media viewer$"] floating enable
        for_window [app_id="^(qbittorrent)$"] move to workspace number 4
        for_window [app_id="^org.qbittorrent.qbittorrent$"] move to workspace number 4
        for_window [class="^qbittorrent$"] move to workspace number 4
        for_window [class="^org.qbittorrent.qbittorrent$"] move to workspace number 4
        for_window [app_id="^spotify$"] move to workspace number 4
        for_window [class="^spotify$"] move to workspace number 4
        for_window [app_id="^org.fooyin.fooyin$"] move to workspace number 4
        for_window [class="^org.fooyin.fooyin$"] move to workspace number 4
        for_window [app_id="^tidal-hifi$"] move to workspace number 4
        for_window [class="^tidal-hifi$"] move to workspace number 4

        # Workspace 5: Mail
        for_window [app_id="^thunderbird$"] move to workspace number 5
        for_window [app_id="^org.mozilla.thunderbird$"] move to workspace number 5
        for_window [app_id="^net.thunderbird.Thunderbird$"] move to workspace number 5
        for_window [class="^thunderbird$"] move to workspace number 5
        for_window [class="^org.mozilla.thunderbird$"] move to workspace number 5
        for_window [class="^net.thunderbird.Thunderbird$"] move to workspace number 5

        # Floating / misc
        for_window [title="(?i).*bitwarden password manager.*"] floating enable, move position center, sticky enable
        for_window [title="(?i)^notificationtoasts"] focus disable
        for_window [app_id="^xdg-desktop-portal-gtk$"] floating enable
        for_window [class="^xdg-desktop-portal-gtk$"] floating enable
        for_window [app_id="^org.keepassxc.KeePassXC$" title="^Generate Password$"] floating enable
        for_window [class="^org.keepassxc.KeePassXC$" title="^Generate Password$"] floating enable
        for_window [app_id="^org.keepassxc.KeePassXC$" title="(?i).*browser access request.*"] floating enable
        for_window [class="^org.keepassxc.KeePassXC$" title="(?i).*browser access request.*"] floating enable
      '';
    };
  };
}
