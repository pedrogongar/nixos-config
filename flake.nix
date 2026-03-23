{
  description = "NixOS — portátil personal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, zen-browser }: let
    homeManagerModule = {
      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit spicetify-nix zen-browser; };
      home-manager.users.occulta     = { ... }: {
        imports = [
          ./home
          spicetify-nix.homeManagerModules.default
          zen-browser.homeModules.beta
        ];
      };
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
