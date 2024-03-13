This is the config for my steam deck, using [Jovian-NixOS](https://jovian-experiments.github.io/Jovian-NixOS/)

Portions of my config are defined in [my base flake](https://github.com/vivlim/nix-base/). 'moduleBundles' are defined in that flake (see [flake.nix](https://github.com/vivlim/nix-base/blob/main/flake.nix))

**You should not use my configuration without modification, since it includes some personalizations you definitely won't want. (e.g. installing my ssh keys)**

This config has the following qualities (at time of writing, and this is not an exhaustive list)

- Full disk encryption + lvm (via nixos-anywhere/disko, see later in this readme)
    - Note that entering the encryption password requires attaching a usb keyboard during boot, at the moment.
- Boots up in gamescope (see ./deck.nix)
- Plasma ([from my base](https://github.com/vivlim/nix-base/blob/main/desktop/plasma.nix))
- [Flatpak support + Discover (defined in my base)](https://github.com/vivlim/nix-base/blob/main/applications/flatpak.nix)
- [nix-ld](https://github.com/Mic92/nix-ld), which allows running unpatched binaries on nixos ([config is in my base](https://github.com/vivlim/nix-base/blob/main/applications/nix-ld.nix))
- obs studio, waydroid, retroarch, some other misc stuff (see ./configuration.nix)
- [support for various game controllers, in my base](https://github.com/vivlim/nix-base/blob/main/gaming-hardware/game-controllers.nix) ([also a tool for the wii u gamecube controller adapter](https://github.com/vivlim/nix-base/blob/main/gaming-hardware/wii-u-gc-adapter.nix), but the udev rules might not work)
- [flakes are enabled and used instead of channels](https://github.com/vivlim/nix-base/blob/dd9b5e20885497a31a950baacce02b3c0f091756/system-base/core.nix#L26)

# How I installed it
I booted the steam deck from nixos install media via [netboot.xyz](https://netboot.xyz/) and used [nixos-anywhere](https://github.com/nix-community/nixos-anywhere)

I *also* tried to use nixos-anywhere directly on steamos but that didn't work.

This config uses [disko](https://github.com/nix-community/disko) to set up lvm with full disk encryption. nixos-anywhere interactively prompts you for a password if you don't provide a secret (which is very nice)
See disk-config.nix for my config. If you want to use this, you'll need to change the path to the disk (I use disk ID with disko so I am less likely to wipe the wrong disk)

```
nix run github:nix-community/nixos-anywhere -- --flake .#vivdeck root@vivdeck-ip-addresss
```

# How I'm pushing changes to it
I'd rather not build on the deck itself since that'll make it hotter than it needs to be. Instead I build on another machine and deploy with [colmena](https://colmena.cli.rs/unstable/), which is a single command:

```
colmena apply -v
```
(the target ip address is configured in flake.nix)
