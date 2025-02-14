{
  description = "viv's steamdeck";
  inputs = {
  # update a single input; nix flake lock --update-input nixpkgs
  # specific commit: nix flake update --override-input nixpkgs github:NixOS/nixpkgs/c6e957d81b96751a3d5967a0fd73694f303cc914
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    jovian = {
      url = "github:jovian-experiments/jovian-nixos/development";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base = {
      url = "github:vivlim/nix-base/unstable";
      #url = "path:/home/vivlim/nix-workspace/nix-base/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

      # Using a wrapper I have in `base` that unpacks 'moduleBundles' defined there.
      machineFactoryArgs = {
          system = "x86_64-linux";
          hostname = "vivdeck";
          inherit inputs;
          modules = [
            disko.nixosModules.disko
            ./configuration.nix
            base.moduleBundles.system-base
            base.moduleBundles.plasma-desktop
            #base.moduleBundles.flatpak # broken on plasma 6?
            ./flatpak.nix
            base.moduleBundles.system-physical
            base.moduleBundles.gaming-hardware
            base.moduleBundles.amd
            sops-nix.nixosModules.sops
            jovian.nixosModules.jovian
            #overlayModule
          ];
        };

    in {
      # nix build .#nixosConfigurations.vivdeck.config.system.build.toplevel
      nixosConfigurations = {
        vivdeck = (base.machineFactory machineFactoryArgs);
      };

      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          specialArgs = {
            inherit inputs;
          };
        };
        vivdeck = (base.colmenaTargetFactory machineFactoryArgs)
        // {
            deployment.targetHost = "100.118.185.120"; # todo: change to tailscale hostname after it's added.
            deployment.targetUser = "root";
        };
      };

      devShells = base.devShells;
    };

}
