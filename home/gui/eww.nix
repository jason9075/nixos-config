{ lib, config, pkgs, ... }:

{
  options.eww_config = {
    pomodoro.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Pomodoro widget.";
    };
    widgets.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable general widgets panel.";
    };
  };

  config = let
    yuckConfig = # yuck
      ''
        ;; CAL VARS
        (defpoll calendar_day :interval "10h" "date '+%d'")
        (defpoll calendar_year :interval "10h" "date '+%Y'")
        (defpoll calendar_date :interval "12h" "date '+%A, %d %B'")
        (defpoll QUOTE :interval "12h" "$HOME/nixos-config/scripts/gen_quote.sh")
        (deflisten CLOCK_DATA "$HOME/nixos-config/scripts/clock.sh")
        (deflisten POMO_DATA "$HOME/nixos-config/scripts/pomodoro.sh listen")

        ;; ENV VARS
        (defpoll UPTIME :interval "1m" "$HOME/nixos-config/scripts/uptime.sh &")
        (defpoll IP_ADDR :interval "24h" "ip -4 -br address | grep UP | grep -vE '^(lo|docker|veth|br-)' | awk '{ print $3 }' | head -n 1")
        (defpoll NET_INTERFACE :interval "24h" "ip -4 -br address | grep UP | grep -vE '^(lo|docker|veth|br-)' | awk '{ print $1}' | head -n 1")
        (defpoll NIXOS_VERSION :interval "24h"
          "nixos-version | sed -E 's/^([0-9]+\\.[0-9]+)\\.[0-9]+\\.[a-z0-9]+ (.*)/\\1 \\2/'")

        ;; Widgets

        (defwidget dash []
          (box :class "dash" :orientation "h")
        )

        (defwidget cal []
          (box :class "cal-container" :orientation "v" :space-evenly "false" :halign "center"
            (box :class "cal-box" :orientation "v" :space-evenly "false"
              (label :class "clock" :text {CLOCK_DATA.time})
              (label :class "date" :text {CLOCK_DATA.today})
            )
            (box :class "cal-window" :orientation "h"
              (calendar :class "day-names month-year"
                        :day calendar_day
                        :year calendar_year
                        :orientation "v")
            )
          )
        )

        (defwidget info []
          (box :class "info-box-outer" :orientation "v" :space-evenly false :halign "center" :spacing 5
            ;; 第一行：Uptime
            (box :class "info-row" :orientation "h" :space-evenly false
              (label :class "info-icon" :text " : ")
              (label :class "info-text" :text "''${UPTIME}")
            )
            ;; 第二行：NixOS Version (獨立一行，字體可稍微縮小)
            (box :class "info-row" :orientation "h" :space-evenly false
              (label :class "info-icon" :text " : ")
              (label :class "info-text" :limit-width 18 :text "''${NIXOS_VERSION}")
            )
          )
        )

        (defwidget network []
          (box :class "network-label" :orientation "h" :space-evenly "false" :spacing 10 :halign "center"
            (label :text "IP ''${IP_ADDR}")
          )
        )

        (defwidget network-up []
          (box :class "network" :orientation "h" :space-evenly "false" :spacing 10 :halign "center"
            (box :orientation "h" :class "network-box"
              (label :text "" :class "network-up")
            )
            (box :orientation "h" :width 100
              (graph :class "network-graph-up"
                     :thickness 2
                     :value {round(EWW_NET[NET_INTERFACE].NET_UP / 1000, 1)}
                     :time-range "2m"
                     :min 0
                     :max 101
                     :dynamic "true"
                     :line-style "round")
            )
          )
        )

        (defwidget network-down []
          (box :class "network" :orientation "h" :space-evenly "false" :spacing 10 :halign "center"
            (box :orientation "h" :class "network-box"
              (label :text "" :width 10 :class "network-down")
            )
            (box :orientation "h" :width 100
              (graph :class "network-graph-down"
                     :thickness 2
                     :value {round(EWW_NET[NET_INTERFACE].NET_DOWN / 1000, 1)}
                     :time-range "2m"
                     :min 0
                     :max 101
                     :dynamic "true"
                     :line-style "round")
            )
          )
        )

        (defwidget right []
          (box :class "right" :orientation "v" :space-evenly "false"
            (cal)
            (dash)
            (network)
            (network-up)
            (network-down)
            (info)
          )
        )

        (defwindow widgets
          :monitor 0
          :geometry (geometry :x "16px"
                              :y "40px"
                              :width "180px"
                              :height "0%"
                              :anchor "top right")
          :stacking "bg"
          :windowtype "dock"
          :exclusive false
          (box :class "main-container"
            (right)
          )
        )
        ;; Clock
        (defwindow clock
          :monitor 0
          :geometry (geometry :x "120px"
                              :y "80px"
                              :width "180px"
                              :height "0%"
                              :anchor "top left")
          :stacking "bg"
          :windowtype "dock"
          :exclusive false
          (box :class "main-container"
            (label :class "clock" :text {CLOCK_DATA.time})
          )
        )
        ;;Quote
        (defwindow quote
          :monitor 0
            :geometry (geometry :x "400px"
                                :y "280px"
                                :width "600px"
                                :height "0%"
                                :anchor "top left")
            :stacking "bg"
            :windowtype "dock"
            :exclusive false
            (box :class "main-container" 
              (label :class "quote" :text "''${QUOTE}")
            )
        )

        ;; CENTER WIDGET CONFIGURATION
        (defwidget music []
          (button :class "center-button" :onclick "$HOME/nixos-config/scripts/browser_toggle_url.sh"
            (box :class "button-group" :orientation "v" :space-evenly "false"
              (label :class "button-icon" :text "")
              (label :class "button-text" :text "音樂")
            )
          )
        )

        (defwidget shutdown []
          (button :class "center-button" :onclick "poweroff"
            (box :class "button-group" :orientation "v" :space-evenly "false"
              (label :class "button-icon" :text "")
              (label :class "button-text" :text "關機")
            )
          )
        )

        (defwidget center-panel []
          (box :class "center-panel" :orientation "h" :spacing 20
            (music)
            (shutdown)
          )
        )

        (defwidget pomodoro []
          (box :class "pomo-container" :orientation "v" :space-evenly false :spacing 5
            (label :class "pomo-status" :text {POMO_DATA.status})
            (label :class "pomo-time" :text {POMO_DATA.time})
            (box :class "pomo-controls" :orientation "h" :space-evenly true
              (button :class "pomo-btn" :onclick "$HOME/nixos-config/scripts/pomodoro.sh toggle" 
                {POMO_DATA.state == "running" ? "󰏤" : "󰐊"}
              )
              (button :class "pomo-btn" :onclick "$HOME/nixos-config/scripts/pomodoro.sh reset" "󰦛")
            )
          )
        )

        (defwindow center
          :monitor 0
          :geometry (geometry :x 0
                              :y "-20%"
                              :anchor "bottom center")
          :stacking "bg"
          :windowtype "dock"
          :exclusive false
          (box :class "center-container"
            (center-panel)
          )
        )

        (defwindow pomodoro
          :monitor 0
          :geometry (geometry :x "20px"
                              :y "20px"
                              :width "150px"
                              :height "0%"
                              :anchor "bottom right")
          :stacking "bg"
          :windowtype "dock"
          :exclusive false
          (box :class "main-container"
            (pomodoro)
          )
        )
      '';

    scssConfig = # css
      ''
        // GENERAL STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        * {
          all: unset;
          font-family: Hack Nerd Font;
          font-size: 14px;
        }

        $white: #f8fbfc;
        $lightgray: #dfe2e3;
        $gray: #c5c8c9;
        $medgray: #797c7d;
        $darkgray: #46494a;
        $black: #1a1b26;

        $color1: #bf616a;
        $color2: #eba0ac;
        $color3: #d08770;
        $color4: #ebcb8b;
        $color5: #b48ead; // purple
        $color6: #e9bdbd;
        $color7: #f5e0dc;
        $color8: #a3be8c;
        $color9: #a3be8c;
        $color10: #8fbcbb;
        $color11: #b48ead;
        $color12: #b48ead;
        $color13: #b48ead;
        $color14: #b48ead;
        $color15: #4e40d4;
        $color16: #5e81ac;
        $color17: #81a1c1; // blue
        $color18: #88c0d0; // cyan
        $color19: #d6ffff;
        $color20: #2e3440;
        $color21: #0d0e19;
        $color22: rgba(13, 14, 25, 0.5);
        $color23: rgba(46, 52, 64, 0.7);
        $color24: rgba(36, 40, 59, 0.5);
        $color25: rgba(13, 14, 25, 0.2);
        $color26: rgba(26, 27, 38, 0.2);

        .main-container {
          background-color: $color23;
          border-radius: 14px;
          margin: 0px 8px 8px 0px;
          box-shadow: 1px 1px 3px 1px #151515;
        }

        .dash {
          background-color: rgba(20, 22, 30, 0.6);
          margin: 4px 16px 2px 16px;
          padding: 2px;
        }
        .info-icon {
          color: $color14;
        }
        .info-text {
          color: $color19;
          font-size: 12px;
        }
        .info-box-outer {
          padding: 8px 0px;
        }
        .info-row {
          margin: 2px 0px;
          min-width: 150px; 
        }
        
        .info-icon {
          color: $color14;
          font-size: 14px;
          margin-right: 5px;
        }
        
        .info-text {
          color: $color19;
          font-size: 12px; 
        }

        .network {
          padding: 5px 0px 5px 0px;
        }
        .network-label {
          color: $color18;
          font-size: 16px;
          font-weight: bold;
          padding: 10px 0px 4px 0px;
        }
        .network-up {
          color: $color14;
          font-size: 20px;
        }
        .network-down {
          color: $color17;
          font-size: 20px;
        }
        .network-graph-up {
          color: $color14;
          padding: 10px;
          background-color: rgba(203, 166, 247, 0.2);
        }
        .network-graph-down {
          color: $color17;
          padding-bottom: 10px;
          background-color: rgba(122, 162, 247, 0.2);
        }

        // CALENDAR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        .cal-container {
          border-radius: 10px;
        }
        .cal-box {
          border-radius: 10px;
        }
        .cal-window {
          border-radius: 10px;
          padding-top: 10px;
        }
        .month-year {
          font-size: 12px;
          font-weight: bold;
          margin: 10px;
          padding: 1px;
          color: $lightgray;
        }
        .day-names {
          margin: 10px;
          font-size: 12px;
          font-weight: bold;
          color: $color10;
        }
        .date {
          color: $color17;
          font-size: 14px;
          font-weight: bold;
          border-radius: 10px;
        }

        .clock {
          font-size: 38px;
          font-weight: bold;
          color: $color13;
          border-radius: 10px;
          padding-top: 6px;
        }
        .quote {
          background-color: $color25;
          font-family: "elffont";
          font-size: 40px;
          color: rgba(255, 255, 255, 0.6);
          border-radius: 10px;
          padding-top: 6px;
        }

        calendar {
          &:selected {
            color: $color9;
          }
          &:indeterminate {
            color: rgba(205, 219, 249, 0.3);
          }
        }
        calendar.button {
          color: $gray;
        }
        calendar.highlight {
          color: $color18;
          font-weight: bold;
          padding: 10px;
          margin: 10px;
        }

        /////////////// center
        .center-container {
          border-radius: 14px;
          margin: 0px 8px 8px 0px;
          box-shadow: 1px 1px 3px 1px #151515;
        }
        .center-panel {
          background-color: $color24;
          border-radius: 20px;
          padding: 12px;
        }

        .center-button:hover {
          background-color: $color22;
        }

        .button-group {
        }

        .button-icon {
          font-size: 200px;
          font-family: Hack Nerd Font Mono;
          color: $white;
          padding: 0px 80px 0px 80px;
        }

        .button-text {
          font-size: 28px;
          color: $white;
        }

        .center-button:hover .button-text,
        .center-button:hover .button-icon {
          color: $color19;
        }

        // POMODORO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        .pomo-container {
          padding: 15px;
          background-color: $color24;
          border-radius: 12px;
        }
        .pomo-status {
          font-size: 16px;
          font-weight: bold;
          color: $color4;
        }
        .pomo-time {
          font-size: 32px;
          font-weight: bold;
          color: $white;
          margin: 5px 0px;
        }
        .pomo-controls {
          margin-top: 10px;
        }
        .pomo-btn {
          font-size: 24px;
          color: $color17;
          padding: 5px;
          border-radius: 8px;
          &:hover {
            background-color: $color22;
            color: $color19;
          }
        }
      '';

  in {

    home.file.".config/eww/eww.yuck".text = yuckConfig;
    home.file.".config/eww/eww.scss".text = scssConfig;

    home.packages = with pkgs; [ eww ];
  };
}
