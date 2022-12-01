{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = 2;
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
        user = "ludovico";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
