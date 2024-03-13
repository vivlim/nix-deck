{ modulesPath, config, lib, pkgs, ... }: {
  # Generic steam deck-specific configs that are reasonable for other people to refer to / use
  jovian.steam = {
    enable = true;

    # Boot straight into gamescope
    autoStart = true;

    # We have to use this instead of services.xserver.displayManager.defaultSession
    # https://jovian-experiments.github.io/Jovian-NixOS/options.html#jovian.steam.desktopSession
    desktopSession = "plasmawayland";

    user = "vivlim"; # it's me!
  };

  # Need to have this or we won't have steam available on the desktop (which is *very* funny)
  programs.steam = {
    enable = true;
    # Runs steam with https://github.com/Supreeeme/extest
    # Without this, steam input on wayland sessions doesn't draw a visible cursor.
    extest.enable = true;
  };

  jovian.decky-loader = {
    enable = true;
  };

  jovian.devices.steamdeck = {
    enable = true; # apply a bunch of deck-specific stuff
    autoUpdate = false; # auto-update firmware / bios. the tools for doing the manually are added to systemPackages below
  };

  environment.systemPackages = with pkgs; [
    maliit-keyboard # onscreen keyboard, integrates with plasma nicely
    steamdeck-firmware # gives us `jupiter-biosupdate` and `jupiter-controller-update` https://jovian-experiments.github.io/Jovian-NixOS/devices/valve-steam-deck/index.html
    jupiter-dock-updater-bin # `jupiter-dock-updater`
  ];
}

