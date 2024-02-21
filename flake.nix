{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nixvim.url = github:pta2002/nixvim;

    rycee = { url = "gitlab:rycee/nur-expressions"; flake = false; };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # apps
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    thorium.url = "github:almahdi/nix-thorium";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nix-alien, nur, nix-doom-emacs, thorium, ... } @inputs: let
    system = "x86_64-linux";
    allowUnfree = { nixpkgs.config.allowUnfree = true; };
  in {
    nixosConfigurations = rec {
        canopus = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            allowUnfree
            ./configuration.nix
            nixos-hardware.nixosModules.common-cpu-amd
            home-manager.nixosModules.home-manager {
	            home-manager.useGlobalPkgs = true;
	            home-manager.useUserPackages = true;
	            home-manager.users.dibusure = import ./home.nix;
	          }

            home-manager.nixosModules.home-manager
            {
              home-manager.users.dibusure = { ... }: {
                imports = [ nix-doom-emacs.hmModule ];
                programs.doom-emacs = {
                  enable = true;
                  doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
                                             # and packages.el files
                };
              };
            }
          ];
      };
    };
  };
}
