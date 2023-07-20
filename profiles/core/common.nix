{
  self,
  pkgs,
  inputs,
  ...
}: {
  # Sets binary caches which speeds up some builds
  imports = [../cachix];

  environment = {
    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd
      firefox
      git
      bottom
      jq
      moreutils
      nix-index
      nmap
      skim
      (ripgrep.override {withPCRE2 = true;})
      tealdeer
      whois
      wl-clipboard

      inputs.self.packages.${pkgs.system}.teavpn2
      inputs.self.packages.${pkgs.system}.multicolor-sddm-theme
    ];
  };

  services.gnome.gnome-keyring.enable = true;
  systemd = {
    user.services.pantheon-agent-polkit = {
      description = "pantheon-agent-polkit";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  nix = {
    package = inputs.nix-super.packages.${pkgs.system}.nix;

    # Improve nix store disk usage
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };

    optimise.automatic = true;

    registry = {
      system.flake = inputs.self;
      default.flake = inputs.nixos;
      nixpkgs.flake = inputs.nixos;
    };

    # Generally useful nix option defaults
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      experimental-features = nix-command flakes ca-derivations
    '';
  };
}
