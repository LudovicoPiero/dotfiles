{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.mine.hyprland;
in
{
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/lua/rules.lua".text = ''
      hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
      hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })

      hl.window_rule({ name = "maximize-event", match = { class = ".*" }, suppress_event = "maximize" })
      hl.window_rule({
          name = "ghost-fix",
          match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
          no_focus = true
      })

      hl.window_rule({ name = "jetbrains", match = { class = "^(jetbrains-.*)$" }, workspace = "1", no_blur = true, no_anim = true })
      hl.window_rule({ name = "albion", match = { class = "^(Albion-Online)$" }, workspace = "1" })

      local secondary = "^(zen|zen-beta|zen-browser|brave-browser|Chromium-browser|chromium-browser|google-chrome|chrome)$"
      hl.window_rule({ name = "secondary-main", match = { class = secondary }, workspace = "2" })
      hl.window_rule({ name = "secondary-perf", match = { class = secondary }, no_blur = true, no_shadow = true, idle_inhibit = "fullscreen" })
      hl.window_rule({ name = "secondary-video", match = { class = secondary, title = "^(.*YouTube.*)$" }, idle_inhibit = "focus" })

      local firefox = "^(Firefox|firefox|firefox-esr|floorp)$"
      hl.window_rule({ name = "firefox-main", match = { class = firefox }, workspace = "3" })
      hl.window_rule({ name = "firefox-perf", match = { class = firefox }, no_blur = true, no_shadow = true, idle_inhibit = "fullscreen" })
      hl.window_rule({ name = "firefox-video", match = { class = firefox, title = "^(.*YouTube.*)$" }, idle_inhibit = "focus" })

      hl.window_rule({ name = "telegram", match = { class = "^(org.telegram.desktop)$" }, workspace = "4", no_anim = true })
      hl.window_rule({ name = "telegram-viewer", match = { class = "^(org.telegram.desktop)$", title = "^(Media viewer)$" }, float = true })
      hl.window_rule({ name = "discord-web", match = { title = "^(.*(Disc|ArmC|WebC)ord.*)$" }, workspace = "4", no_blur = true, no_shadow = true })
      hl.window_rule({ name = "vesktop", match = { class = "^(vesktop)$" }, workspace = "4" })

      hl.window_rule({ name = "mail", match = { class = "^(thunderbird|org.mozilla.Thunderbird)$" }, workspace = "5" })

      hl.window_rule({ name = "steam-main", match = { class = "^(steam)$" }, workspace = "6" })
      hl.window_rule({ name = "steam-signin", match = { title = "^(Sign in to Steam)$" }, workspace = "6" })
      hl.window_rule({ name = "steam-offers", match = { class = "^(steam)$", title = "^(Special Offers)$" }, float = true })
      hl.window_rule({ name = "steam-news", match = { class = "^(steam)$", title = "^(Steam - News)$" }, float = true, no_initial_focus = true })
      hl.window_rule({ name = "steam-toasts", match = { class = "^(steam)$", title = "^(notificationtoasts_.*_desktop)$" }, no_focus = true })
      hl.window_rule({ name = "steam-toasts-generic", match = { class = "^(steam)$", title = "^notificationtoasts.*" }, no_initial_focus = true })
      hl.window_rule({ name = "steam-empty", match = { class = "^(steam)$", title = "^$" }, no_focus = true })

      hl.window_rule({ name = "torrent", match = { class = "^(qBittorrent|org.qbittorrent.qBittorrent)$" }, workspace = "7" })
      hl.window_rule({ name = "whatsapp", match = { class = "^(whatsapp-for-linux)$" }, workspace = "8" })

      hl.window_rule({ name = "spotify", match = { class = "^(spotify)$" }, workspace = "9" })
      hl.window_rule({ name = "fooyin", match = { class = "^(org.fooyin.fooyin)$" }, workspace = "9" })
      hl.window_rule({ name = "tidal", match = { class = "^(tidal-hifi)$" }, workspace = "9" })
      hl.window_rule({ name = "foobar", match = { class = "^(foobar2000.exe)$" }, workspace = "9", tile = true, no_anim = true })

      hl.window_rule({ name = "bitwarden", match = { title = "^(.*Bitwarden Password Manager.*)$" }, float = true, center = true, pin = true })
      hl.window_rule({ name = "toasts", match = { title = "^notificationtoasts.*" }, no_focus = true })
      hl.window_rule({ name = "portal-gtk", match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true, no_blur = true })

      hl.window_rule({ name = "keepass-main", match = { class = "^(org.keepassxc.KeePassXC)$" }, no_blur = true, no_anim = true })
      hl.window_rule({ name = "keepass-gen", match = { class = "^(org.keepassxc.KeePassXC)$", title = "^(Generate Password)$" }, float = true })
      hl.window_rule({ name = "keepass-request", match = { class = "^(org.keepassxc.KeePassXC)$", title = "^(KeePassXC - Browser Access Request)$" }, float = true })
    '';
  };
}
