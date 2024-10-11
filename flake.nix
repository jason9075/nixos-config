{
  description = "My personal flake";

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager-unstable
    , home-manager-stable, ... }:

    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        machine = "taipei";
        timezone = "Asia/Taipei";
        locale = "zh_TW.UTF-8";
        useUnstable = true; # Use unstable nixpkgs
        bootMode = "uefi"; # uefi or bios
        grubDevice =
          ""; # device identifier for grub; only used for legacy (bios) boot mode
      };
      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "jason9075"; # username
        name = "jason9075"; # name/identifier
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        wm =
          "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        wmType = if (wm == "hyprland") then "wayland" else "x11";
        browser =
          "firefox"; # Default browser; must select one from ./user/app/browser/
        defaultRoamDir =
          "Personal.p"; # Default org roam directory relative to ~/Org
        term = "kitty"; # Default terminal command;
        editor = "nvim"; # Default editor;
      };
      pkgs = (if systemSettings.useUnstable then
        (import nixpkgs {
          system = systemSettings.system;
          config = { allowUnfree = true; };
        })
      else
        nixpkgs);
      pkgs-stable = import nixpkgs-stable {
        system = systemSettings.system;
        config = { allowUnfree = true; };
      };
      lib =
        if systemSettings.useUnstable then nixpkgs.lib else nixpkgs-stable.lib;
      home-manager = home-manager-unstable;
    in {
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/machines" + ("/" + systemSettings.machine)
              + "/configuration.nix")
          ];
          specialArgs = {
            inherit pkgs;
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
          };
        };
      };
      homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          inherit pkgs;
          inherit pkgs-stable;
          inherit (inputs) nixvim;
          inherit systemSettings;
          inherit userSettings;
        };
      };
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ];
            text = ''${./install.sh} "$@"'';
          };
        });
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    hyprland.url = "github:hyprwm/hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

}
