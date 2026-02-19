{
  description = "NixOS dev VM + escritorio";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: let
    homeManagerModule = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.pedro = import ./home;
    };
  in {
    nixosConfigurations = {
      nixos-dev = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vm
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };

      nixos-escritorio = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/escritorio
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };
    };
  };
}
