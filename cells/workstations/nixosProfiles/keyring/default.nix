{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  programs.dconf.enable = true;
  # Fixes the org.a11y.Bus not provided by .service file error
  services.gnome.at-spi2-core.enable = true;
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = [nixpkgs.libsecret];
  services.dbus.packages = [nixpkgs.gnome.seahorse];

  systemd = {
    user.services.pantheon-agent-polkit = {
      description = "pantheon-agent-polkit";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${nixpkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
