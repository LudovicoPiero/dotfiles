{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [fuzzel];
    #TODO: Move this somewhere else
    xdg.configFile."fuzzel/fuzzel.ini".text = ''
      font='Iosevka Nerd Font-16'
      icon-theme='WhiteSur'
      prompt='->'
      [dmenu]
      mode=text
      [colors]
      background=24283bff
      text=a9b1d6ff
      match=8031caff
      selection=8031caff
      selection-text=7aa2f7ff
      selection-match=2ac3deff
      border=8031caff

      [border]
      width=2
      radius=0
    '';
  };
}
