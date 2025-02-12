{pkgs, lib, ...}: {
  hardware.pulseaudio.enable = lib.mkDefault true;
  hardware.pulseaudio.support32Bit = lib.mkDefault true;    ## If compatibility with 32-bit applications is desired.

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
