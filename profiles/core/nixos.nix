{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./common.nix
  ];

  environment = {
    # completion for system packages (e.g. systemd).
    pathsToLink = ["/share/fish"];
    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux
    ];

    shellAliases = let
      ifSudo = lib.mkIf config.security.sudo.enable;
    in {
      # nix
      nrb = ifSudo "sudo nixos-rebuild";

      # fix nixos-option for flake compat
      nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

      # systemd
      ctl = "systemctl";
      stl = ifSudo "s systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = ifSudo "s systemctl start";
      dn = ifSudo "s systemctl stop";
      jtl = "journalctl";
    };
  };

  nix = {
    settings = {
      # Prevent impurities in builds
      sandbox = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel"];
    };

    # Improve nix store disk usage
    settings.auto-optimise-store = true;
    optimise.automatic = true;
  };

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  # Service that makes Out of Memory Killer more effective
  services.earlyoom.enable = true;
}
