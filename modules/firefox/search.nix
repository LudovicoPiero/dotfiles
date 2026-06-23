_: {
  hm = {
    programs.firefox = {
      profiles.ludovico = {
        search = {
          default = "Brave";
          privateDefault = "Google (No AI)";
          force = true;
          engines = {
            duckduckgo = {
              urls = [ { template = "https://duckduckgo.com/?q={searchTerms}&kp=-2&kl=wt-wt"; } ];
              name = "DuckDuckGo";
              definedAliases = [ "ddg" ];
            };
            "Google (No AI)" = {
              urls = [
                {
                  template = "https://www.google.com/search?hl=en&pws=0&udm=14&safe=off&brd_browser=chrome&q={searchTerms}";
                }
              ];
              name = "Google (No AI)";
              definedAliases = [ "g" ];
            };
            "Brave" = {
              urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
              name = "Brave";
              definedAliases = [ "b" ];
            };

            # Nix
            "Home Manager Options" = {
              urls = [ { template = "https://nix-community.github.io/home-manager/options/home-manager/index.html?search={searchTerms}"; } ];
              name = "Home Manager Options";
              definedAliases = [ "hm" ];
            };
            "Nix Packages" = {
              urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
              name = "Nix Packages";
              definedAliases = [ "np" ];
            };
            "Nix Options" = {
              urls = [ { template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; } ];
              name = "Nix options";
              definedAliases = [ "no" ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
              name = "NixOS Wiki";
              definedAliases = [ "nw" ];
            };

            "Github Code" = {
              urls = [ { template = "https://github.com/search?q={searchTerms}&type=code"; } ];
              name = "Github Code";
              definedAliases = [ "ghc" ];
            };
            "Github Repos" = {
              urls = [ { template = "https://Github.com/search?q={searchTerms}&type=repositories"; } ];
              name = "Github Repos";
              definedAliases = [ "ghr" ];
            };
          };
        };
      };
    };
  };
}
