{
  description = "NixOS — portátil personal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: let
    homeManagerModule = {
      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;
      home-manager.users.pedro     = import ./home;
    };
  in {
    nixosConfigurations = {
      nixos-portatil = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/portatil
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };
    };
  };
}
