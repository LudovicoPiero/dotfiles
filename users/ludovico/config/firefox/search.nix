{pkgs}: {
  default = "Brave";
  force = true;
  engines = {
    "Brave" = {
      urls = [{template = "https://search.brave.com/search?q={searchTerms}";}];
      definedAliases = ["@b"];
    };
    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@np"];
    };
    "Home-Manager" = {
      urls = [
        {
          template = "https://rycee.gitlab.io/home-manager/options.html";
        }
      ];
      definedAliases = ["@hm"];
    };
    "NixOS Options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@no"];
    };

    "NixOS Wiki" = {
      urls = [
        {
          template = "https://nixos.wiki/index.php?search={searchTerms}";
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@nw"];
    };
  };
}
