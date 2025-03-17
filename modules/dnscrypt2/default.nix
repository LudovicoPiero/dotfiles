{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;

  cfg = config.myOptions.dnscrypt2;
in
{
  options.myOptions.dnscrypt2 = {
    enable = mkEnableOption "dnscrypt2 service";

    hasIPv6Internet = mkOption {
      type = types.bool;
      default = false;
    };

    StateDirectory = mkOption {
      type = types.str;
      default = "dnscrypt-proxy";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
      dhcpcd.extraConfig = "nohook resolv.conf"; # If using dhcpcd
      networkmanager.dns = "none"; # If using NetworkManager
    };

    services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        server_names = [
          "cs-singapore"
          "dnscry.pt-jakarta-ipv4"
          "dnscry.pt-singapore-ipv4"
          "dnscry.pt-singapore02-ipv4"
          "doh.tiar.app"
          "doh.tiar.app-doh"
          "iij"
          "jp.tiar.app"
        ];

        max_clients = 250;

        # Use servers reachable over IPv4
        ipv4_servers = true;
        # Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
        ipv6_servers = cfg.hasIPv6Internet;
        # Use servers implementing the DNSCrypt protocol
        dnscrypt_servers = true;
        # Use servers implementing the DNS-over-HTTPS protocol
        doh_servers = true;
        # Server must support DNS security extensions (DNSSEC)
        require_dnssec = true;
        # Server must not log user queries (declarative)
        require_nolog = true;
        # Server must not enforce its own blacklist (for parental control, ads blocking...)
        require_nofilter = true;
        force_tcp = false;

        ## How long a DNS query will wait for a response, in milliseconds
        timeout = 2500;
        ## Keepalive for HTTP (HTTPS, HTTP/2) queries, in seconds
        keepalive = 30;

        ## Automatic log files rotation
        # Maximum log files size in MB
        log_files_max_size = 10;
        # How long to keep backup files, in days
        log_files_max_age = 7;
        # Maximum log files backups to keep (or 0 to keep all backups)
        log_files_max_backups = 1;

        ## Do not enable if you added a validating resolver such as dnsmasq in front
        ## of the proxy.
        block_ipv6 = !cfg.hasIPv6Internet;

        ###########################
        #        DNS cache        #
        ###########################
        ## Enable a DNS cache to reduce latency and outgoing traffic
        cache = true;
        ## Cache size
        cache_size = 512;
        ## Minimum TTL for cached entries
        cache_min_ttl = 600;
        ## Maximum TTL for cached entries
        cache_max_ttl = 86400;
        ## Minimum TTL for negatively cached entries
        cache_neg_min_ttl = 60;
        ## Maximum TTL for negatively cached entries
        cache_neg_max_ttl = 600;

        ###########################
        #        Sources          #
        ###########################
        sources = {
          public-resolvers = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
              "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            ];
            cache_file = "/var/lib/${cfg.StateDirectory}/public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          };
          # relays = {
          #   urls = [
          #     "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
          #     "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
          #   ];
          #   cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
          #   minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          # };
        };

        # anonymized_dns = {
        #   routes = [
        #     {
        #       server_name = "*";
        #       via = [
        #         "anon-cs-singapore"
        #         "anon-saldnssg01-conoha-ipv4"
        #         "anon-tiarap"
        #         "dnscry.pt-anon-singapore-ipv4"
        #       ];
        #     }
        #   ];
        #   skip_incompatible = true;
        # };
      };
    };

    systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = cfg.StateDirectory;
  };
}
