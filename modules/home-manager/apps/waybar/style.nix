{
  config,
  lib,
  ...
}: let
  inherit (config.colorScheme) colors;
in
  # https://github.com/theCode-Breaker/riverwm/blob/main/waybar/river/river_style.css
  ''
       * {
       	border: none;
       	border-radius: 6px;
        font-family: "UbuntuMono Nerd Font" ;
       	font-size: 15px;
       	min-height: 10px;
       }

       window#waybar {
       	background: transparent;
       }

       window#waybar.hidden {
       	opacity: 0.2;
       }

       #window {
       	margin-top: 2px;
       	padding-left: 10px;
       	padding-right: 10px;
       	border-radius: 5px;
       	transition: none;
        color: transparent;
       	background: transparent;
       }

       #workspaces {
       	margin-top: 3px;
       	margin-left: 12px;
       	font-size: 4px;
       	margin-bottom: 0px;
       	border-radius: 5px;
       	background: #${colors.base00};
       	transition: none;
       }

       #workspaces button {
       	transition: none;
       	color: #${colors.base0C};
       	background: transparent;
       	font-size: 16px;
       }

       #workspaces button:hover {
       	transition: none;
       	box-shadow: inherit;
       	text-shadow: inherit;
        border-color: #${colors.base08};
        color: #${colors.base08};
       }

       #workspaces button.active {
        color: #${colors.base08};
       }

       #workspaces button.active:hover {
           color: #${colors.base08};
       }

       #network {
       	margin-top: 3px;
       	margin-left: 8px;
       	padding-left: 10px;
       	padding-right: 10px;
       	margin-bottom: 0px;
       	border-radius: 5px;
       	transition: none;
       	color: #${colors.base00};
       	background: #${colors.base0E};
       }

       #pulseaudio {
       	margin-top: 3px;
       	margin-left: 8px;
       	padding-left: 10px;
       	padding-right: 10px;
       	margin-bottom: 0px;
       	border-radius: 5px;
       	transition: none;
       	color: #${colors.base00};
       	background: #${colors.base09};
       }

       #battery {
       	margin-top: 3px;
       	margin-left: 8px;
       	padding-left: 10px;
       	padding-right: 10px;
       	margin-bottom: 0px;
       	border-radius: 5px;
       	transition: none;
       	color: #${colors.base00};
       	background: #${colors.base0D};
       }

       #battery.charging, #battery.plugged {
       	   color: #${colors.base00};
           background-color: #${colors.base0D};
       }

       #battery.critical:not(.charging) {
           background-color: #${colors.base0D};
           color: #${colors.base00};
           animation-name: blink;
           animation-duration: 0.5s;
           animation-timing-function: linear;
           animation-iteration-count: infinite;
           animation-direction: alternate;
       }

       @keyframes blink {
           to {
               background-color: #${colors.base08};
               color: #${colors.base09};
           }
       }

       #clock {
       	margin-top: 3px;
       	margin-left: 8px;
       	padding-left: 10px;
       	padding-right: 10px;
       	margin-bottom: 0px;
       	border-radius: 5px;
       	transition: none;
       	color: #${colors.base00};
       	background: #${colors.base0B};
       }

       #tray {
       	margin-top: 3px;
       	margin-left: 8px;
       	padding-left: 10px;
       	margin-bottom: 0px;
       	padding-right: 10px;
       	border-radius: 5px;
       	transition: none;
       	background: #${colors.base01};
       }

    #custom-date {
    	margin-top: 3px;
    	margin-left: 8px;
    	padding-left: 10px;
    	padding-right: 10px;
    	margin-bottom: 0px;
    	border-radius: 5px;
    	transition: none;
    	color: #${colors.base00};
    	background: #${colors.base08};
    }
  ''
