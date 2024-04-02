{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  emacs-git = pkgs.emacs-git.override {
    withTreeSitter = true;
    withNativeCompilation = true;
    withPgtk = true;
  };
in {
  home.activation.setup-emacs-config = lib.hm.dag.entryBefore ["writeBoundary"] ''
    CONFIG="${config.xdg.configHome}/emacs"

    if [ ! -d "$CONFIG" ]; then
      ${pkgs.git}/bin/git clone --filter=tree:0 https://github.com/ludovicopiero/.emacs.d.git $CONFIG
    fi

    chown -R ${config.home.username}:users ${config.xdg.configHome}/emacs
  '';

  services.emacs = {
    enable = true; # Using hyprland's exec-once
    package = config.programs.emacs.finalPackage;
    socketActivation.enable = true;
    client.arguments = ["-c"];
  };
  programs.emacs = {
    enable = true;
    package = inputs.wrapper-manager.lib.build {
      inherit pkgs;
      modules = [
        {
          wrappers.emacs = {
            basePackage =
              (pkgs.emacsPackagesFor emacs-git).emacsWithPackages
              (epkgs: [epkgs.vterm epkgs.general epkgs.no-littering]);

            pathAdd = with pkgs; [
              # Nix
              alejandra
              nil
              deadnix
              statix

              # Lua
              lua-language-server
              stylua

              # Python
              nodePackages.pyright
              isort
              black

              # C/C++
              gcc
              cmake
              clang
              clang-tools # for headers stuff

              # Go
              go
              gopls
              gotools

              # Rust
              rust-analyzer

              # Etc
              ripgrep
              fd
              nodePackages.prettier
              shfmt
              gnumake
            ];
          };
        }
      ];
    };
  };
}
