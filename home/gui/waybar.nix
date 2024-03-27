{ pkgs, ... }:

let
  waybarConfig = builtins.toJSON {
    "layer"="top";
    "height"= 36;
    "margin-top"= 4;
    "margin-left"= 10;
    "margin-right"= 10;

    "modules-left"= ["hyprland/workspaces" "custom/mpd"];
    "modules-center"= ["clock" "custom/wallpaper"];
    "modules-right"= ["cpu" "temperature" "memory" "disk" "backlight" "pulseaudio" "tray" "custom/power"];

    "hyprland/workspaces"= {
      "on-click"= "activate";
      "all-outputs"= true;
      "persistent-workspaces"= {
          "1"= [];
          "2"= [];
          "3"= [];
          "4"= [];
          "5"= [];
          "6"= [];
          "7"= [];
          "8"= [];
          "9"= [];
          "10"= [];
       };
      "format"= "{icon}";
      # https://www.nerdfonts.com/cheat-sheet
      "format-icons"= {
          "10"= "";
          "9"= "";
          "8"= "󰒱";
          "7"= "󰙯";
       };
    };
    "keyboard-state"= {
      "numlock"= true;
      "capslock"= true;
      "format"= "{name} {icon}";
      "format-icons"= {
          "locked"= "";
          "unlocked"= "";
      };
    };
    "wlr/taskbar"= {
      "format"= "{icon}";
      "icon-size"= 18;
      "tooltip-format"= "{title}";
      "on-click"= "activate";
      "on-click-middle"= "close";
      "ignore-list"= [
         "kitty"
      ];
    };
    "tray"= {
      "icon-size"= 18;
      "spacing"= 5;
      "show-passive-items"= true;
    };
    "clock"= {
      "interval"= 60;
      "format"= "  {:%b %d %a  %p %I:%M}";
      "tooltip-format"= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };
    "temperature"= {
      "critical-threshold"= 80;
      "interval"= 2;
      "format"= "{temperatureC}°C ";
      "format-icons"= ["" "" ""];
    };
    "cpu"= {
      "interval"= 2;
      "format"= "  {usage}%";
      "tooltip"= false;
      "states" = {
        "mid"= 90;
        "high"= 95;
      };
    };
    "memory"= {
      "interval"= 2;
      "format"= " {}%";
    };
    "disk"= {
      "interval"= 15;
      "format"= "󰋊 {percentage_used}%";
      "states"= {
        "mid"= 90;
        "high"= 95;
      };
    };
    "backlight"= {
      "format"= "{icon} {percent}%";
      "format-icons"= ["" "" "" "" "" "" "" "" ""];
    };
    "battery"= {
      "states"= {
        "good"= 95;
        "warning"= 30;
        "critical"= 15;
      };
      "format"= "{icon} {capacity}%";
      "format-charging"= " {capacity}%";
      "format-plugged"= " {capacity}%";
      "format-alt"= "{icon} {time}";
      "format-icons"= ["" "" "" "" ""];
    };
    "battery#bat2"= {
      "bat"= "BAT2";
    };
    "network"= {
      "format-wifi"= " :{ipaddr}";
      "format-ethernet"= " {ipaddr}/{cidr}";
      "tooltip-format-wifi"= " {essid} ({signalStrength}%)";
      "tooltip-format"= " {ifname} via {gwaddr}";
      "format-linked"= " {ifname} (No IP)";
      "format-disconnected"= "⚠ Disconnected";
      "format-alt"= "{ifname}: {ipaddr}/{cidr}";
    };
    "pulseaudio"= {
      # "scroll-step"= 1; 
      "format"= "{icon} {volume}%"; 
      "format-bluetooth"= "{icon} {volume}% 󰂯"; 
      "format-bluetooth-muted"= "{icon} 󰖁 󰂯"; 
      "format-muted"= "󰖁 {format_source}";
      "format-source"= " {volume}%";
      "format-source-muted"= "";
      "format-icons"= {
        "headphone"= "󰋋";
        "hands-free"= "󱡒";
        "headset"= "󰋎";
        "phone"= "";
        "portable"= "";
        "car"= "";
        "default"= ["" "" ""];
      };
      "on-click"= "pavucontrol";
    };
    "custom/wallpaper"={
      "format"= " {icon} ";
      "format-icons"= "󰸉";
      "on-click"= "~/nixos-config/scripts/swww_randomize.sh";
      "tooltip"= false;
    };
    "custom/power"= {
      "format"= "{icon} ";
      "format-icons"= "";
      "exec-on-event"= "true";
      "on-click"= "wlogout";
    };
    "custom/mpd"= {
      "exec"= "mpc current";
      "interval"= 1;
      "format"= "🎵 {} ";
      "format-alt"= "mpc toggle";
      "on-click"= "mpc toggle";
      "on-click-right"= "mpc next";
      "on-click-middle"= "mpc prev";
      "tooltip"= false;
    };
  };
  waybarStyle = ''
    @define-color bg rgba(4, 20, 45, 0.50);
    @define-color bg-alt #252428;
    @define-color fg #f5f5f5;
    @define-color alert #bf616a;
    @define-color disabled #a5a5a5;
    @define-color bordercolor #4b4950;
    @define-color highlight #FBD47F;
    @define-color activegreen #8fb666;
    @define-color nordblue #81a1c1;
    @define-color nordyellow #ebcb8b;
    @define-color nordgray #abb1bb;
    
    * {
      min-height: 0;
      font-family: "Hack Nerd Font", FontAwesome, Roboto,
        Helvetica, Arial, sans-serif;
      font-size: 15px;
    }
    
    window#waybar {
      color: #f5f5f5;
      background: @bg00;
      transition-property: background-color;
      transition-duration: 0.5s;
    }
    
    window#waybar.empty {
      opacity: 0.6;
    }
    
    .modules-left {
      background: @bg;
      border: 1px solid @bordercolor;
      border-radius: 8px;
    
      padding-right: 5px;
      padding-left: 5px;
    }
    
    .modules-right {
      background: @bg;
      border: 1px solid @bordercolor;
      border-radius: 8px;
    
      padding-right: 5px;
      padding-left: 5px;
    }
    
    .modules-center {
      background: @bg;
      border: 1px solid @bordercolor;
      border-radius: 8px;
    
      padding-right: 5px;
      padding-left: 5px;
    }
    
    button {
      /* Use box-shadow instead of border so the text isn't offset */
      box-shadow: inset 0 -3px transparent;
      /* Avoid rounded borders under each button name */
      border: none;
      border-radius: 0;
    }
    
    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    button:hover {
      background: inherit;
      box-shadow: inset 0 -3px transparent;
    }
    
    #workspaces button {
      /* background-color: #252428; */
      color: @fg;
    }
    
    #workspaces button.urgent {
      color: @alert;
      /* background-color: #252428; */
      /* border: 3px solid #f53c3c; */
    }
    #workspaces button.empty {
      color: @disabled;
      /* background-color: #252428; */
    }
    
    #workspaces button.active {
      color: @nordblue;
      /* background-color: #252428; */
      /* border: 3px solid #7bcbd5; */
    }
    
    #workspaces button.focused {
      background-color: @fg;
      color: @bg-alt;
    }
    
    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #pulseaudio.muted,
    #wireplumber,
    #custom-media,
    #taskbar,
    #tray,
    #tray menu,
    #tray > .needs-attention,
    #tray > .passive,
    #tray > .active,
    #mode,
    #idle_inhibitor,
    #scratchpad,
    #custom-power {
      padding: 0px 5px;
      padding-right: 10px;
      margin: 3px 3px;
      color: @fg;
    }
    
    #custom-mpd {
      animation: blinker 4s ease-in infinite;
    }
    @keyframes blinker {
      50% {
          opacity: 0.8;
      }
    }

    #custom-power {
      color: @nordgray;
    }

    #custom-wallpaper {
      color: @nordblue;
    }
    
    #cpu {
      color: @nordblue;
    }

    #cpu.mid {
      color: @nordtyellow;
    }

    #cpu.high {
      color: @alert;
    }
    
    #temperature {
      color: @nordblue;
    }
    
    #temperature.critical {
      background-color: @alert;
    }
    
    #memory {
      color: @nordblue;
    }
    
    #disk {
      color: @nordblue;
    }

    #disk.mid {
      background-color: @nordyellow;
    }

    #disk.high {
      background-color: @alert;
    }
    
    #backlight {
      color: #679c68;
    }
    
    #pulseaudio {
      color: @nordblue;
    }
    
    #clock {
      color: @nordblue;
      font-weight: bold;
    }
    
    #battery {
      color: #48aa4c;
    }
    
    #network {
      color: #5cc084;
    }
    
    label:focus {
      background-color: #000000;
    }
    
    #network.disconnected {
      background-color: @alert;
    }
    
    #battery.charging,
    #battery.plugged {
      color: #f5f5f5;
      background-color: #26a65b;
    }
    
    #wireplumber.muted {
      background-color: @alert;
    }
    
    #language {
      background: @fg;
      color: @bg-alt;
      padding: 0 5px;
      margin: 0 5px;
      min-width: 16px;
    }
    
    /* If workspaces is the leftmost module, omit left margin */
    .modules-left > widget:first-child > #workspaces {
      margin-left: 0;
    }
    
    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
      margin-right: 0;
    }
    @keyframes blink {
      to {
        background-color: @fg;
        color: @bg-alt;
      }
    }
    
    #battery.critical:not(.charging) {
      background-color: @alert;
      color: @fg;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }
  '';
in {
  home.file.".config/waybar/config".text = waybarConfig;
  home.file.".config/waybar/style.css".text = waybarStyle;

  programs.waybar = {
    enable = true;
  };
}
