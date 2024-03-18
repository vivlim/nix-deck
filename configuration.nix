{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
    ./deck.nix
    ./onscreen-keyboard.nix
  ];

  viv.usePatchedVlc = true;

  # just kind of a grab bag of stuff
  environment.systemPackages = with pkgs; [
    tailscale
    rustup
    moonlight-qt
    sunshine
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture 
        obs-livesplit-one
        obs-multi-rtmp
        obs-vaapi
        obs-gstreamer
        input-overlay
        obs-3d-effect
        obs-composite-blur
        obs-gradient-source
        obs-vkcapture # Launch games with `obs-gamecapture %command%` to capture.
        waveform
      ];
    })
    (retroarch.override {
      cores = with libretro; [
        bsnes
        bsnes-mercury-balanced
        gambatte
        genesis-plus-gx
        gpsp
        mgba
        mupen64plus
        parallel-n64
        sameboy
        snes9x
        tgbdual
        vba-next
      ];
    })
    wl-clipboard # used by waydroid (among other things)
  ];

  boot.supportedFilesystems = [ "ntfs" ]; # i would like to be able towrite to ntfs please

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
}
