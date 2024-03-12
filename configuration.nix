{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
  ];

  jovian.steam = {
    enable = true;
    autoStart = true;

    desktopSession = "plasmawayland";

    user = "vivlim";

  };

  jovian.decky-loader = {
    enable = true;
  };

  jovian.devices.steamdeck = {
    enable = true;
    autoUpdate = false; # firmware / bios. not sure if i want it yet
  };

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  networking.networkmanager.enable = true;
  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

  # these were set in base.
  # session is specified in jovian.steam.desktopSession instead.
  services.xserver.displayManager.defaultSession = lib.mkForce null;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;
}
