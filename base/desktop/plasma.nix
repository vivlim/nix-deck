{pkgs, lib, ...}:{
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.displayManager.defaultSession = lib.mkDefault "plasma";
  services.desktopManager.plasma6.enable = lib.mkDefault true;

  programs.kdeconnect.enable = lib.mkDefault true;

  # configure gtk apps
  programs.dconf.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    lightly-qt
    catppuccin-kde
    catppuccin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    wl-clipboard
  ];

  programs.partition-manager.enable = true;
}
