{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/release-23.11";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";
    rycee = { url = "gitlab:rycee/nur-expressions"; flake = false; };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nix-alien, nur, nixvim, ... } @inputs: let
    system = "x86_64-linux";
    allowUnfree = { nixpkgs.config.allowUnfree = true; };
  in {
    nixosConfigurations = rec {
        mini = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs system nixvim; };
          modules = [
            allowUnfree
            nixvim.nixosModules.nixvim
            ./configuration.nix
            #./modules/neovim/neovim.nix
            nixos-hardware.nixosModules.common-cpu-amd
            home-manager.nixosModules.home-manager {
	            home-manager.useGlobalPkgs = true;
	            home-manager.useUserPackages = true;
	            home-manager.users.dibusure = import ./home.nix;
	          }

            home-manager.nixosModules.home-manager
          ];
      };
    };
};
}
