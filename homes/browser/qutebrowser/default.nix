{config, ...}: let
  inherit (config.colorScheme) colors;
in {
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://nixos.wiki/index.php?search={}";
      g = "https://www.google.com/search?hl=en&q={}";
      dg = "https://duckduckgo.com/?q={}";
    };
    settings = {
      # https://github.com/tinted-theming/base16-qutebrowser/blob/main/templates/default.mustache
      colors = {
        webpage.preferred_color_scheme = "dark";
        completion = {
          fg = "#${colors.base05}";
          odd.bg = "#${colors.base01}";
          even.bg = "#${colors.base00}";
          category = {
            fg = "#${colors.base0A}";
            bg = "#${colors.base00}";
          };
          category = {
            border.top = "#${colors.base00}";
            border.bottom = "#${colors.base00}";
          };
          item = {
            selected.fg = "#${colors.base05}";
            selected.bg = "#${colors.base02}";
            selected.border.top = "#${colors.base02}";
            selected.border.bottom = "#${colors.base02}";
            selected.match.fg = "#${colors.base0B}";
          };
        };
        completion = {
          match.fg = "#${colors.base0B}";
          scrollbar.fg = "#${colors.base05}";
          scrollbar.bg = "#${colors.base00}";
        };
        contextmenu.disabled.bg = "#${colors.base01}";
        contextmenu.disabled.fg = "#${colors.base04}";
        contextmenu.menu.bg = "#${colors.base00}";
        contextmenu.menu.fg = "#${colors.base05}";
        contextmenu.selected.bg = "#${colors.base02}";
        contextmenu.selected.fg = "#${colors.base05}";
        downloads.bar.bg = "#${colors.base00}";
        downloads.start.fg = "#${colors.base00}";
        downloads.start.bg = "#${colors.base0D}";
        downloads.stop.fg = "#${colors.base00}";
        downloads.stop.bg = "#${colors.base0C}";
        downloads.error.fg = "#${colors.base08}";
        hints.fg = "#${colors.base00}";
        hints.bg = "#${colors.base0A}";
        hints.match.fg = "#${colors.base05}";
        keyhint.fg = "#${colors.base05}";
        keyhint.suffix.fg = "#${colors.base05}";
        keyhint.bg = "#${colors.base00}";
        messages.error.fg = "#${colors.base00}";
        messages.error.bg = "#${colors.base08}";
        messages.error.border = "#${colors.base08}";
        messages.warning.fg = "#${colors.base00}";
        messages.warning.bg = "#${colors.base0E}";
        messages.warning.border = "#${colors.base0E}";
        messages.info.fg = "#${colors.base05}";
        messages.info.bg = "#${colors.base00}";
        messages.info.border = "#${colors.base00}";
        prompts.fg = "#${colors.base05}";
        prompts.border = "#${colors.base00}";
        prompts.bg = "#${colors.base00}";
        prompts.selected.bg = "#${colors.base02}";
        prompts.selected.fg = "#${colors.base05}";
        statusbar.normal.fg = "#${colors.base0B}";
        statusbar.normal.bg = "#${colors.base00}";
        statusbar.insert.fg = "#${colors.base00}";
        statusbar.insert.bg = "#${colors.base0D}";
        statusbar.passthrough.fg = "#${colors.base00}";
        statusbar.passthrough.bg = "#${colors.base0C}";
        statusbar.private.fg = "#${colors.base00}";
        statusbar.private.bg = "#${colors.base01}";
        statusbar.command.fg = "#${colors.base05}";
        statusbar.command.bg = "#${colors.base00}";
        statusbar.command.private.fg = "#${colors.base05}";
        statusbar.command.private.bg = "#${colors.base00}";
        statusbar.caret.fg = "#${colors.base00}";
        statusbar.caret.bg = "#${colors.base0E}";
        statusbar.caret.selection.fg = "#${colors.base00}";
        statusbar.caret.selection.bg = "#${colors.base0D}";
        statusbar.progress.bg = "#${colors.base0D}";
        statusbar.url.fg = "#${colors.base05}";
        statusbar.url.error.fg = "#${colors.base08}";
        statusbar.url.hover.fg = "#${colors.base05}";
        statusbar.url.success.http.fg = "#${colors.base0C}";
        statusbar.url.success.https.fg = "#${colors.base0B}";
        statusbar.url.warn.fg = "#${colors.base0E}";
        tabs.bar.bg = "#${colors.base00}";
        tabs.indicator.start = "#${colors.base0D}";
        tabs.indicator.stop = "#${colors.base0C}";
        tabs.indicator.error = "#${colors.base08}";
        tabs.odd.fg = "#${colors.base05}";
        tabs.odd.bg = "#${colors.base01}";
        tabs.even.fg = "#${colors.base05}";
        tabs.even.bg = "#${colors.base00}";
        tabs.pinned.even.bg = "#${colors.base0C}";
        tabs.pinned.even.fg = "#${colors.base07}";
        tabs.pinned.odd.bg = "#${colors.base0B}";
        tabs.pinned.odd.fg = "#${colors.base07}";
        tabs.pinned.selected.even.bg = "#${colors.base02}";
        tabs.pinned.selected.even.fg = "#${colors.base05}";
        tabs.pinned.selected.odd.bg = "#${colors.base02}";
        tabs.pinned.selected.odd.fg = "#${colors.base05}";
        tabs.selected.odd.fg = "#${colors.base05}";
        tabs.selected.odd.bg = "#${colors.base02}";
        tabs.selected.even.fg = "#${colors.base05}";
        tabs.selected.even.bg = "#${colors.base02}";
      };
    };
  };
}
