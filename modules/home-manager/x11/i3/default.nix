{
  pkgs,
  config,
  ...
} @ args: {
  imports = [
    ../../apps/i3status
    ../../apps/picom
  ];

  home.packages = with pkgs; [feh];

  xsession = {
    enable = true;
    scriptPath = ".xsession-i3";
    windowManager = {
      i3 = {
        enable = true;
        config = {
          assigns = import ./assigns.nix args; # Workspace rules
          keybindings = import ./keybindings.nix args;
          startup = import ./startup.nix args;
          colors = import ./colors.nix args;
          window.border = 2;
          floating.border = 1;
          window.commands = [
            {
              # Remove titlebar
              command = "border pixel 2";
              criteria = {class = "^.*";};
            }
          ];
          bars = [
            {
              fonts = {
                names = ["UbuntuMono Nerd Font"];
                size = 10.0;
              };
              position = "bottom";
              statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
            }
          ];
          defaultWorkspace = "workspace number 1";
          focus = {
            followMouse = true;
            forceWrapping = false;
            mouseWarping = false;
            newWindow = "smart";
          };
          fonts = {
            names = ["UbuntuMono Nerd Font" "Monospace"];
            size = 11.0;
          };
          modifier = "Mod4";
          terminal = "kitty";
        };
      };
    };
  };
}
