{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
    ./deck.nix
    #./onscreen-keyboard.nix
  ];

  #viv.usePatchedVlc = false;

  # just kind of a grab bag of stuff
  environment.systemPackages = with pkgs; [
    tailscale
    rustup
    moonlight-qt
    sunshine
    wl-clipboard # used by waydroid (among other things)
    nil
  ];

  boot.supportedFilesystems = [ "ntfs" ]; # i would like to be able towrite to ntfs please

  boot.initrd.systemd.enable = true;
  boot.initrd.lizard-askpass.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraUpFlags = [
    ];
  };

  virtualisation = {
    waydroid.enable = true;
  };

  networking.firewall = {
    enable = true;
    interfaces = {
      tailscale0 = {
        allowedTCPPortRanges = []; # [{ from = 1000; to = 2000; }]
        allowedUDPPortRanges = []; # [{ from = 1000; to = 2000; }]
      };
    };
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

  # unfree as in unfreedom
  nixpkgs.config.allowUnfree = true;

  # these were set in base.
  # session is specified in jovian.steam.desktopSession instead.
  services.xserver.displayManager.defaultSession = lib.mkForce null;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;

  nixpkgs.config.permittedInsecurePackages = [ "SDL_ttf-2.0.11" ];
}
