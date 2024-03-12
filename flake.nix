{
  description = "viv's steamdeck";
  inputs = { # update a single input; nix flake lock --update-input nixpkgs
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    jovian = {
      url = "github:jovian-experiments/jovian-nixos/development";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base = {
      url = "github:vivlim/nix-base/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #base = { url = "path:/home/vivlim/git/nix-base/"; };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, jovian, base, disko, sops-nix, ... }:
    let
      overlayModule =
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ jovian.overlays.default ]; });
      machineFactory = base.machineFactory;
      colmenaTargetFactory = base.colmenaTargetFactory;
    in {
      # nix build .#nixosConfigurations.vivdeck.config.system.build.toplevel
      nixosConfigurations = with base; {
        vivdeck = (machineFactory {
          system = "x86_64-linux";
          hostname = "vivdeck";
          inherit inputs;
          modules = [
            disko.nixosModules.disko
            ./configuration.nix
            moduleBundles.system-base
            moduleBundles.plasma-desktop
            moduleBundles.system-physical
            moduleBundles.gaming-hardware
            moduleBundles.amd
            sops-nix.nixosModules.sops
            jovian.nixosModules.jovian
            overlayModule
          ];
        });
      };

      devShells = base.devShells;
    };

}
