_: {
  hm = {
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "JetBrains Mono";
        font-size = 15;
        background-opacity = 1.0;
        window-decoration = false;
        confirm-close-surface = false;
        cursor-style = "block";
        cursor-style-blink = false;
        mouse-hide-while-typing = true;

        keybind = [
          "ctrl+a>v=new_split:down"
          "ctrl+a>;=new_split:right"
          "ctrl+a>c=new_tab"
          "ctrl+a>1=goto_tab:1"
          "ctrl+a>2=goto_tab:2"
          "ctrl+a>3=goto_tab:3"
          "ctrl+a>4=goto_tab:4"
          "ctrl+a>5=goto_tab:5"
          "ctrl+a>6=goto_tab:6"
          "ctrl+a>7=goto_tab:7"
          "ctrl+a>8=goto_tab:8"
          "alt+h=resize_split:left,20"
          "alt+j=resize_split:down,20"
          "alt+k=resize_split:up,20"
          "alt+l=resize_split:right,20"
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+j=goto_split:down"
          "ctrl+shift+k=goto_split:up"
          "ctrl+shift+l=goto_split:right"
          "ctrl+equal=increase_font_size:1"
          "ctrl+minus=decrease_font_size:1"
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
        ];
      };
    };
  };
}
