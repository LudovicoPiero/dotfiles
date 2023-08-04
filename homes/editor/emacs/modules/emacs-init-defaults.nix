# A collection of "uncontroversial" configurations for selected packages.
# https://gitlab.com/rycee/nur-expressions/-/blob/master/hm-modules/emacs-init-defaults.nix
{
  pkgs,
  lib,
  ...
}: {
  programs.emacs.init.usePackage = {
    all-the-icons = {extraPackages = [pkgs.emacs-all-the-icons-fonts];};

    cmake-mode.mode = [
      ''"\\.cmake\\'"'' # \
      ''"CMakeLists.txt\\'"''
    ];

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

    dap-lldb = {
      config = ''
        (setq dap-lldb-debug-program "${pkgs.lldb}/bin/lldb-vscode")
      '';
    };

    deadgrep = {
      config = ''
        (setq deadgrep-executable "${pkgs.ripgrep}/bin/rg")
      '';
    };

    dhall-mode.mode = [''"\\.dhall\\'"''];

    dockerfile-mode.mode = [''"Dockerfile\\'"''];

    elm-mode.mode = [''"\\.elm\\'"''];

    latex.mode = [''("\\.tex\\'" . latex-mode)''];

    lsp-elm = {
      config = ''
        (setq lsp-elm-elm-language-server-path
                "${pkgs.elmPackages.elm-language-server}/bin/elm-language-server")
      '';
    };

    lsp-eslint = {
      config = ''
        (setq lsp-eslint-server-command '("node" "${pkgs.vscode-extensions.dbaeumer.vscode-eslint}/share/vscode/extensions/dbaeumer.vscode-eslint/server/out/eslintServer.js" "--stdio"))
      '';
    };

    lsp-pylsp = {
      config = ''
        (setq lsp-pylsp-server-command
                "${lib.getExe pkgs.python3Packages.python-lsp-server}")
      '';
    };

    markdown-mode = {
      mode = [''"\\.mdwn\\'"'' ''"\\.markdown\\'"'' ''"\\.md\\'"''];
    };

    nix-mode.mode = [''"\\.nix\\'"''];

    octave.mode = [''("\\.m\\'" . octave-mode)''];

    org-roam = {
      defines = ["org-roam-graph-executable"];
      config = ''
        (setq org-roam-graph-executable "${pkgs.graphviz}/bin/dot")
      '';
    };

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
