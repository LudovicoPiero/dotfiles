{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  _ = lib.getExe;
in {
  imports = [inputs.nix-index-database.hmModules.nix-index];

  programs = {
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
    zoxide.enable = true;
  };

  programs.fish = with pkgs; {
    enable = true;

    functions = import ./__functions.nix {inherit lib pkgs inputs config;};
    shellAliases = import ./__shellAliases.nix {inherit lib pkgs config;};

    interactiveShellInit = let
      inherit (config.colorScheme) palette;
    in ''
      set --global async_prompt_functions _pure_prompt_git
      set --universal pure_check_for_new_release false
      set pure_symbol_prompt "❯"
      set pure_color_success '#${palette.base0E}'

      ${_ any-nix-shell} fish --info-right | source
    '';

    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "e5d54b93cd3e096ad6c2a419df33c4f50451c900";
          hash = "sha256-5cO5Ey7z7KMF3vqQhIbYip5JR6YiS2I9VPRd6BOmeC8=";
        };
      }
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "pure-fish";
          repo = "pure";
          rev = "v4.11.0";
          hash = "sha256-8zxqPU9N5XGbKc0b3bZYkQ3yH64qcbakMsHIpHZSne4=";
        };
      }
      {
        name = "fish-async-prompt";
        src = pkgs.fetchFromGitHub {
          owner = "acomagu";
          repo = "fish-async-prompt";
          rev = "316aa03c875b58e7c7f7d3bc9a78175aa47dbaa8";
          hash = "sha256-J7y3BjqwuEH4zDQe4cWylLn+Vn2Q5pv0XwOSPwhw/Z0=";
        };
      }
    ];
  };
}
