{
  description = "Jason Kuan's flake file";

outputs = inputs@{ self, ... }:
    let
      # Shared settings for all machines
      defaultSettings = {
        timezone = "Asia/Taipei";
        locale = "zh_TW.UTF-8";
        bootMountPath = "/boot";
        grubDevice = "";
        bootMode = "uefi";
      };
      users = {
         clawbot = {
           username = "clawbot";
           name = "Jason Kuan";
           email = "jason9075@gmail.com";
           term = "kitty";
         };
        taipei = {
          username = "jason";
          name = "Jason Kuan";
          email = "jason9075@gmail.com";
        };
        vbox = {
          username = "vbox";
          name = "Hello VirtualBox";
          email = "vbox@localhost";
        };
        home-msi = {
          username = "kuan";
          name = "Hello Kuan";
          email = "kuan@localhost";
        };
        taoyuan = {
          username = "kuan";
          name = "Kuan";
          email = "kuan@localhost";
        };
        taoyuan-dad = {
          username = "kuan";
          name = "Kuan";
          email = "kuan@localhost";
        };
        sahisi = {
          username = "sahisi";
          name = "上海興";
          email = "sahisi@localhost";
        };
      };
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
        overlays = [ ];
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      };
      home-manager = inputs.home-manager-unstable;

      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor =
        forAllSystems (system: import inputs.nixpkgs { inherit system; });
    in {
       nixosConfigurations = {
         clawbot = inputs.nixpkgs.lib.nixosSystem {
           inherit pkgs;
           system = "x86_64-linux";
           modules = [
             ./machines/clawbot/configuration.nix
             inputs.stylix.nixosModules.stylix
           ];
           specialArgs = {
             inherit pkgs-stable;
             systemSettings = defaultSettings;
             userSettings = users.clawbot;
           };
         };
        taipei = inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          modules = [
            ./machines/taipei/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit pkgs-stable;
            systemSettings = defaultSettings;
            userSettings = users.taipei;
          };
        };
        vbox = inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          modules = [
            ./machines/vbox/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit pkgs-stable;
            systemSettings = defaultSettings;
            userSettings = users.vbox;
          };
        };
        home-msi = inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          modules = [
            ./machines/home-msi/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit pkgs-stable;
            systemSettings = defaultSettings;
            userSettings = users.home-msi;
          };
        };
        taoyuan = inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          modules = [
            ./machines/taoyuan/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit pkgs-stable;
            systemSettings = defaultSettings;
            userSettings = users.taoyuan;
          };
        };
        taoyuan-dad = inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          modules = [
            ./machines/taoyuan-dad/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit pkgs-stable;
            systemSettings = defaultSettings;
            userSettings = users.taoyuan-dad;
          };
        };
        sahisi = inputs.nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = "x86_64-linux";
          modules = [
            ./machines/sahisi/configuration.nix
            inputs.stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit pkgs-stable;
            systemSettings = defaultSettings;
            userSettings = users.sahisi;
          };
        };
      };
       homeConfigurations = {
         clawbot = inputs.home-manager-unstable.lib.homeManagerConfiguration {
           pkgs = pkgs;
           extraSpecialArgs = {
             inherit inputs pkgs pkgs-stable;
             userSettings = users.clawbot;
           };
           modules = [
             ./machines/clawbot/home.nix
           ];
         };
        taipei = inputs.home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs pkgs pkgs-stable;
            userSettings = users.taipei;
          };
          modules = [
            ./machines/taipei/home.nix
          ];
        };
        vbox = inputs.home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs pkgs pkgs-stable;
            userSettings = users.vbox;
          };
          modules = [
            ./machines/vbox/home.nix
          ];
        };
        home-msi = inputs.home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs pkgs pkgs-stable;
            userSettings = users.home-msi;
          };
          modules = [
            ./machines/home-msi/home.nix
          ];
        };
        taoyuan = inputs.home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs pkgs pkgs-stable;
            userSettings = users.taoyuan;
          };
          modules = [
            ./machines/taoyuan/home.nix
          ];
        };
        taoyuan-dad = inputs.home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs pkgs pkgs-stable;
            userSettings = users.taoyuan-dad;
          };
          modules = [
            ./machines/taoyuan-dad/home.nix
          ];
        };
        sahisi = inputs.home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs pkgs pkgs-stable;
            userSettings = users.sahisi;
          };
          modules = [
            ./machines/sahisi/home.nix
          ];
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
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
    hyprshutdown = {
      url = "github:hyprwm/hyprshutdown";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix/v1.16.5-6703236727046144";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };
}
