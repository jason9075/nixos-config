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
      action = "systemctl syspend";
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
          @define-color nordblue #81a1c1;
      * {
      	background-image: none;
      }
      window {
      	background-color: rgba(46, 52, 64, 0.9);
      }
      button {
      	background-color: #2e3440;
      	border-style: solid;
      	border-width: 0px;
      	border-radius: 0;
      	background-repeat: no-repeat;
      	background-position: center;
      	background-size: 25%;
      	color: #5e81ac;
      }

      button:focus, button:active, button:hover {
      	background-color: #4c566a;
      	color: #81a1c1;
      	outline-style: none;
      }

      #lock {
          background-image: image(url("/usr/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
      }

      #logout {
          background-image: image(url("/usr/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
      }

      #suspend {
          background-image: image(url("/usr/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
          background-image: image(url("/usr/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
          background-image: image(url("/usr/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
          background-image: image(url("/usr/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
      }    
    '';
in {

  programs.wlogout = {
    enable = true;
    layout = wlogoutLayout;
    # style = wlogoutStyle;
  };
}
