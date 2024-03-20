{
  description = "My personal flake";

  outputs = { nixpkgs, home-manager, ... }@inputs:

  let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux";
      hostname = "nixos"; 
      machine = "desktop";
      timezone = "Asia/Taipei";
      locale = "zh_TW.UTF-8";
    };
    # ----- USER SETTINGS ----- #
    userSettings = rec {
      username = "jason9075"; # username
      name = "jason9075"; # name/identifier
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      theme = "uwunicorn-yt"; # selcted theme from my themes directory (./themes/)
      wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
      # window manager type (hyprland or x11) translator
      wmType = if (wm == "hyprland") then "wayland" else "x11";
      browser = "qutebrowser"; # Default browser; must select one from ./user/app/browser/
      defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
      term = "kitty"; # Default terminal command;
      editor = "nvim"; # Default editor;
    };
    # pkgs = nixpkgs.legacyPackages.${systemSettings.system};
    pkgs = import nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
      };
    };
    lib = nixpkgs.lib;
  in {
    homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
      extraSpecialArgs = {
        inherit inputs;
        inherit systemSettings;
        inherit userSettings;
      };
    };
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [ (./. + "/machines"+("/"+systemSettings.machine)+"/configuration.nix") ];
        specialArgs = {
          inherit pkgs;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";


  };

}
