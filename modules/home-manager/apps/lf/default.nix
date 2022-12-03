{pkgs,lib,...}:
{
    home.packages = with pkgs;[mpv 
    lf];
xdg.configFile."lf".source = ./config;
}
