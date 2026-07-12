{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.mine.i3wm;
in
{

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];
      xdg.config.files."i3/window-rules".text = ''
        gaps inner 2
        gaps outer 2
        smart_gaps on
        smart_borders on

        # Browser marks
        for_window [class="Chromium-browser"] mark Browser
        for_window [class="Brave-browser"] mark Browser
        for_window [class="firefox"] mark Browser
        for_window [class="Firefox"] mark Browser
        for_window [class="zen"] mark Browser
        for_window [class="Zen"] mark Browser
        for_window [class="floorp"] mark Browser
        for_window [class="Floorp"] mark Browser
        for_window [class="Google-chrome"] mark Browser
        for_window [class="chrome"] mark Browser
        for_window [con_mark="Browser" title="(?i)youtube"] fullscreen enable
        for_window [class="firefox" title="Firefox — Sharing Indicator"] floating enable

        # Workspace 1: Dev / Games
        for_window [class="(?i)^jetbrains-"] move to workspace number 1
        for_window [class="^Albion Online Launcher$"] move to workspace number 1
        for_window [class="^Albion-Online$"] move to workspace number 1
        for_window [class="^Steam$"] move to workspace number 1
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
        for_window [class="^Steam$" title="^$"] focus disable
        for_window [class="^foobar2000.exe$"] move to workspace number 1, floating disable

        # Workspace 2: Browsers
        for_window [class="(?i)firefox"] move to workspace number 2
        for_window [class="(?i)floorp"] move to workspace number 2
        for_window [class="(?i)zen"] move to workspace number 2
        for_window [class="(?i)brave-browser"] move to workspace number 2
        for_window [class="(?i)chromium-browser"] move to workspace number 2
        for_window [class="(?i)google-chrome"] move to workspace number 2
        for_window [class="(?i)chrome"] move to workspace number 2

        # Workspace 3: Chat (Vesktop / Discord)
        for_window [class="^[Vv]esktop$"] move to workspace number 3

        # Workspace 4: Telegram
        for_window [class="^TelegramDesktop$"] move to workspace number 4
        for_window [class="^telegram-desktop$"] move to workspace number 4
        for_window [class="^TelegramDesktop$" title="^Media viewer$"] floating enable
        for_window [class="^telegram-desktop$" title="^Media viewer$"] floating enable

        # Workspace 7: xxx
        for_window [class="^qbittorrent$"] move to workspace number 7
        for_window [class="^org.qbittorrent.qbittorrent$"] move to workspace number 7

        # Workspace 9: Music
        for_window [class="^[Ss]potify$"] move to workspace number 9
        for_window [class="^org.fooyin.fooyin$"] move to workspace number 9
        for_window [class="^tidal-hifi$"] move to workspace number 9

        # Workspace 10: Mail
        for_window [class="^[Tt]hunderbird$"] move to workspace number 10
        for_window [class="^org.mozilla.thunderbird$"] move to workspace number 10
        for_window [class="^net.thunderbird.Thunderbird$"] move to workspace number 10

        # Floating / misc
        for_window [title="(?i).*bitwarden password manager.*"] floating enable, move position center, sticky enable
        for_window [title="(?i)^notificationtoasts"] focus disable
        for_window [class="^Xdg-desktop-portal-gtk$"] floating enable
        for_window [class="^org.keepassxc.KeePassXC$" title="^Generate Password$"] floating enable
        for_window [class="^KeePassXC$" title="^Generate Password$"] floating enable
        for_window [class="^org.keepassxc.KeePassXC$" title="(?i).*browser access request.*"] floating enable
        for_window [class="^KeePassXC$" title="(?i).*browser access request.*"] floating enable
      '';
    };
  };
}
