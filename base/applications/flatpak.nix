{pkgs, ...}:{
  environment.systemPackages = let 
    discover-wrapped = pkgs.symlinkJoin # https://github.com/Toomoch/nixos-config/blob/master/system/modules/de.nix
      {
        name = "discover-flatpak-backend";
        paths = [ pkgs.libsForQt5.discover ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/plasma-discover --add-flags "--backends flatpak"
        '';
      };
  in [
    discover-wrapped
  ];

  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";
}
