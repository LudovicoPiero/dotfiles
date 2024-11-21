{ pkgs, ... }:
[
  {
    name = "pure";
    src = pkgs.fishPlugins.pure.src;
  }
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
    name = "fish-async-prompt";
    src = pkgs.fetchFromGitHub {
      owner = "acomagu";
      repo = "fish-async-prompt";
      rev = "316aa03c875b58e7c7f7d3bc9a78175aa47dbaa8";
      hash = "sha256-J7y3BjqwuEH4zDQe4cWylLn+Vn2Q5pv0XwOSPwhw/Z0=";
    };
  }
]
