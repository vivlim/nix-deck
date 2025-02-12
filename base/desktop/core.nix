{pkgs, lib, ...}:{
  users.users.vivlim = {
    extraGroups = [ "users" "audio" "video" ]; # Enable ‘sudo’ for the user.
  };
  #services.xserver.enable = lib.mkDefault true;
  services.displayManager.sddm.wayland.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    vlc
    usbutils
  ];
}
