{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
