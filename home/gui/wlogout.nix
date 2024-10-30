{ pkgs, ... }:

let
  wlogoutLayout = [
    {
      label = "lock";
      action = "swaylock";
      text = "Lock (l)";
      keybind = "l";
    }
    {
      label = "hibernate";
      action = "systemctl hibernate";
      text = "Hibernate (h)";
      keybind = "h";
    }
    {
      label = "logout";
      action = "loginctl terminate-user $USER";
      text = "Logout (e)";
      keybind = "e";
    }
    {
      label = "shutdown";
      action = "systemctl poweroff";
      text = "Shutdown (s)";
      keybind = "s";
    }
    {
      label = "suspend";
      action = "systemctl suspend";
      text = "Suspend (u)";
      keybind = "u";
    }
    {
      label = "reboot";
      action = "systemctl reboot";
      text = "Reboot (r)";
      keybind = "r";
    }
  ];
  wlogoutStyle = # css
    ''
      @define-color bg rgba(46, 52, 64, 0.8);
      @define-color bg-focus rgba(76, 86, 106, 0.8);
      @define-color blue #5e81ac;
      @define-color green #8fbcbb;
      * {
        background-image: none;
      }

      window {
        background-color: @bg;
      }

      button {
        background-color: @bg;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-style: solid;
        border-width: 0px;
        border-radius: 0;
        font-size: 24px;
        font-family: "Hack Nerd Font";
        color: @blue;
        padding: 20px;
      }

      button:focus,
      button:active,
      button:hover {
        background-color: @bg-focus;
        background-size: 30%;
        color: @green;
        outline-style: none;
      }

      #lock {
        background-image: url("../../nixos-config/assets/lock.png");
      }

      #logout {
        background-image: url("../../nixos-config/assets/logout.png");
      }

      #suspend {
        background-image: url("../../nixos-config/assets/suspend.png");
      }

      #hibernate {
        background-image: url("../../nixos-config/assets/hibernate.png");
      }

      #shutdown {
        background-image: url("../../nixos-config/assets/shutdown.png");
      }

      #reboot {
        background-image: url("../../nixos-config/assets/reboot.png");
      }
    '';
in {

  programs.wlogout = {
    enable = true;
    layout = wlogoutLayout;
    style = wlogoutStyle;
  };
}
