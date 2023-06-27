# A collection of "uncontroversial" configurations for selected packages.
{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.emacs.init.usePackage = {
    all-the-icons = {extraPackages = [pkgs.emacs-all-the-icons-fonts];};

    csharp-mode.mode = [''"\\.cs\\'"''];

    cue-mode = {
      package = epkgs:
        epkgs.trivialBuild {
          pname = "cue-mode.el";
          src = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/russell/cue-mode/9c803ee8fa4a6e99c7dc9ae373c6178569583b7a/cue-mode.el";
            sha256 = "0swhpknkg1vwbchblzrwynixf5grg95jy1bkc8w92yfpb1jch7m7";
          };
          preferLocalBuild = true;
          allowSubstitutes = true;
        };
      command = ["cue-mode"];
      mode = [''"\\.cue\\'"''];
      hook = ["(cue-mode . subword-mode)"];
    };

    dhall-mode.mode = [''"\\.dhall\\'"''];

    dockerfile-mode.mode = [''"Dockerfile\\'"''];

    elm-mode.mode = [''"\\.elm\\'"''];

    emacsql-sqlite3 = {
      enable =
        lib.mkDefault config.programs.emacs.init.usePackage.org-roam.enable;
      defer = lib.mkDefault true;
      config = ''
        (setq emacsql-sqlite3-executable "${pkgs.sqlite}/bin/sqlite3")
      '';
    };

    ggtags = {
      config = ''
        (setq ggtags-executable-directory "${pkgs.global}/bin")
      '';
    };

    idris-mode = {
      mode = [''"\\.idr\\'"''];
      config = ''
        (setq idris-interpreter-path "${pkgs.idris}/bin/idris")
      '';
    };

    kotlin-mode = {
      mode = [''"\\.kts?\\'"''];
      hook = ["(kotlin-mode . subword-mode)"];
    };

    latex.mode = [''("\\.tex\\'" . latex-mode)''];

    lsp-eslint = {
      config = ''
        (setq lsp-eslint-server-command '("node" "${pkgs.vscode-extensions.dbaeumer.vscode-eslint}/share/vscode/extensions/dbaeumer.vscode-eslint/server/out/eslintServer.js" "--stdio"))
      '';
    };

    markdown-mode = {
      mode = [''"\\.mdwn\\'"'' ''"\\.markdown\\'"'' ''"\\.md\\'"''];
    };

    nix-mode.mode = [''"\\.nix\\'"''];

    octave.mode = [''("\\.m\\'" . octave-mode)''];

    pandoc-mode = {
      config = ''
        (setq pandoc-binary "${pkgs.pandoc}/bin/pandoc")
      '';
    };

    php-mode.mode = [''"\\.php\\'"''];

    protobuf-mode.mode = [''"\\.proto\\'"''];

    purescript-mode.mode = [''"\\.purs\\'"''];

    ripgrep = {
      config = ''
        (setq ripgrep-executable "${pkgs.ripgrep}/bin/rg")
      '';
    };

    rust-mode.mode = [''"\\.rs\\'"''];

    terraform-mode.mode = [''"\\.tf\\'"''];

    yaml-mode.mode = [''"\\.\\(e?ya?\\|ra\\)ml\\'"''];
  };
}
