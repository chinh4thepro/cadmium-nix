inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
  };
};

outputs = inputs @ { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      cadmium-builder = lib.nixosSystem {
        inherit system;
        modules = [
          ./cadmium-nix/configuration.nix
          home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit self;
              }; 
              home-manager.users.builder = ./cadmium-builder/builder-home;
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };
  }
