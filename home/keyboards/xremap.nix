{ ... }:

{
  services.xremap = {
    debug = true;
    withWlroots = true;
    config = {
      modmap = [
        {
          name = "CapsLock to Ctrl";
          remap = {
            "CapsLock" = "Ctrl_L";
          };
        }
      ];
      keymap = [
        # {
        #   name = "kitty";
        #   remap = {
        #     super-i = {
        #         launch = [ "kitty" ];
        #     };
        #   };
        # }
        # { 
        #   name = "Ctrl+h to Left";
        #   remap = {
        #       C-h = "left";
        #   };
        # }
        # { 
        #   name = "Ctrl+j to down";
        #   remap = {
        #       C-j = "down";
        #   };
        # }
        # { 
        #   name = "Ctrl+k to up";
        #   remap = {
        #       C-k = "up";
        #   };
        # }
        # { 
        #   name = "Ctrl+l to right";
        #   remap = {
        #       C-l = "right";
        #   };
        # }
      ];

    };
  };
}
