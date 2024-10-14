{
  description = "Jason Kuan flake file";

  outputs = inputs@{ self, ... }:
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
        bootMountPath = "/boot"; # boot mount point
        grubDevice =
          ""; # device identifier for grub; only used for legacy (bios) boot mode
        # version = "24.05"; # Stable version
        version = "24.11"; # Unstable version
      };
      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "jason9075"; # username
        name = "Jason Kuan"; # name/identifier
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        browser =
          "firefox"; # Default browser; must select one from ./user/app/browser/
        defaultRoamDir =
          "Personal.p"; # Default org roam directory relative to ~/Org
        term = "kitty"; # Default terminal command;
        editor = "nvim"; # Default editor;
        version = "24.11";
      };
      pkgs = (if systemSettings.useUnstable then
        (import inputs.nixpkgs {
          system = systemSettings.system;
          config = { allowUnfree = true; };
        })
      else
        inputs.nixpkgs);
      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = { allowUnfree = true; };
      };
      lib = if systemSettings.useUnstable then
        inputs.nixpkgs.lib
      else
        inputs.nixpkgs-stable.lib;
      home-manager = inputs.home-manager-unstable;

      # Systems that can run tests:
      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor =
        forAllSystems (system: import inputs.nixpkgs { inherit system; });
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
        modules = [
          (./. + "/machines" + ("/" + systemSettings.machine) + "/home.nix")
        ];
        extraSpecialArgs = {
          inherit pkgs;
          inherit pkgs-stable;
          inherit (inputs) nixvim;
          inherit userSettings;
        };
      };
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git vim ];
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
