{
  pkgs,
  inputs,
  ...
} @ args: {
  home.packages = with pkgs; [
    # Utils
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = import ./settings.nix args;
    plugins = [inputs.hy3.packages.${pkgs.system}.hy3];
    extraConfig = ''
      plugin {
        hy3 {
          # disable gaps when only one window is onscreen
          no_gaps_when_only = false # default: false

          # policy controlling what happens when a node is removed from a group,
          # leaving only a group
          # 0 = remove the nested group
          # 1 = keep the nested group
          # 2 = keep the nested group only if its parent is a tab group
          node_collapse_policy = 2 # default: 2

          # offset from group split direction when only one window is in a group
          group_inset = 10 # default: 10

          # tab group settings
          tabs {
            # height of the tab bar
            height = 5 # default: 15

            # padding between the tab bar and its focused node
            padding = 5 # default: 5

            # the tab bar should animate in/out from the top instead of below the window
            from_top = false # default: false

            # rounding of tab bar corners
            rounding = 3 # default: 3

            # render the window title on the bar
            render_text = false # default: true

            # font to render the window title with
            text_font = "Iosevka q" # default: Sans

            # height of the window title
            text_height = 8 # default: 8

            # left padding of the window title
            text_padding = 3 # default: 3

            # active tab bar segment color
            col.active = 0xff62d6e8 # default: 0xff32b4ff

            # urgent tab bar segment color
            col.urgent = 0xffea51b2 # default: 0xffff4f4f

            # inactive tab bar segment color
            col.inactive = 0xff3a3c4e # default: 0x80808080

            # active tab bar text color
            col.text.active = 0xff282936 # default: 0xff000000

            # urgent tab bar text color
            col.text.urgent = 0xff282936 # default: 0xff000000

            # inactive tab bar text color
            col.text.inactive = 0xffe9e9f4 # default: 0xff000000
          }

          # autotiling settings
          autotile {
            # enable autotile
            enable = false # default: false

            # make autotile-created groups ephemeral
            ephemeral_groups = true # default: true

            # if a window would be squished smaller than this width, a vertical split will be created
            # -1 = never automatically split vertically
            # 0 = always automatically split vertically
            # <number> = pixel height to split at
            trigger_width = 0 # default: 0

            # if a window would be squished smaller than this height, a horizontal split will be created
            # -1 = never automatically split horizontally
            # 0 = always automatically split horizontally
            # <number> = pixel height to split at
            trigger_height = 0 # default: 0
          }
        }
      }
    '';
  };
}
