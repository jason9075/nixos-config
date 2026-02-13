{ pkgs, ... }: {
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "user";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 5;
      timeout-low = 5;
      timeout-critical = 0;
    };
    style = ''
      /* Minimal Nord Theme for SwayNC */
      * {
        font-family: "Hack Nerd Font";
      }

      .notification-row {
        outline: none;
      }

      .notification {
        background: #5e81ac; /* Nord10 */
        border-radius: 8px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px #4c566a; /* Nord3 */
        padding: 0;
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 8px;
      }

      .close-button {
        background: #bf616a; /* Nord11 */
        color: #eceff4; /* Nord6 */
        text-shadow: none;
        padding: 0;
        border-radius: 100%;
        margin-top: 10px;
        margin-right: 16px;
        box-shadow: none;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        box-shadow: none;
        background: #d08770; /* Nord12 */
        transition: all .15s ease-in-out;
        border: none;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: #4c566a; /* Nord3 */
        border: 1px solid #2e3440; /* Nord0 */
        color: #eceff4; /* Nord6 */
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: #5e81ac; /* Nord10 */
      }

      .notification-default-action {
        border-radius: 8px;
      }

      /* Control Center */
      .control-center {
        background: #2e3440; /* Nord0 */
        border-radius: 8px;
        border: 2px solid #4c566a; /* Nord3 */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.5);
      }
      
      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
      }

      .floating-notifications {
        background: transparent;
      }

      /* Widgets */
      .widget-title {
        color: #eceff4; /* Nord6 */
        background: #4c566a; /* Nord3 */
        padding: 8px;
        margin: 8px;
        border-radius: 8px;
      }

      .widget-title > button {
        font-size: initial;
        color: #eceff4; /* Nord6 */
        text-shadow: none;
        background: #4c566a; /* Nord3 */
        border: 1px solid #eceff4; /* Nord6 */
        box-shadow: none;
        border-radius: 8px;
      }

      .widget-title > button:hover {
        background: #5e81ac; /* Nord10 */
      }
      
      .widget-dnd {
        background: #4c566a; /* Nord3 */
        padding: 8px;
        margin: 8px;
        border-radius: 8px;
      }
      
      .widget-dnd > switch {
        border-radius: 8px;
        background: #4c566a; /* Nord3 */
      }
      
      .widget-dnd > switch:checked {
        background: #81a1c1; /* Nord9 */
      }
      
      .widget-dnd > switch slider {
        background: #eceff4; /* Nord6 */
        border-radius: 8px;
      }

      .widget-label {
        margin: 8px;
      }

      .widget-label > label {
        font-size: 1.1rem;
      }
      
      .widget-mpris {
        color: #eceff4; /* Nord6 */
        background: #4c566a; /* Nord3 */
        padding: 8px;
        margin: 8px;
        border-radius: 8px;
      }
      
      .widget-mpris > box > button {
        border-radius: 8px;
      }
    '';
  };

  home.packages = with pkgs; [ libnotify ];
}
