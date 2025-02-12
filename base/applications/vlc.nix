{ modulesPath, config, lib, pkgs, ... }: let
cfg = config.viv;
vlc = let
  vlcPatched = pkgs.vlc.overrideAttrs (old: rec {
    # workaround for wide subtitles, https://www.reddit.com/r/VLC/comments/17sprje/comment/kaljwmo/?utm_source=reddit&utm_medium=web2x&context=3
    patches = old.patches ++ [
      (pkgs.fetchpatch {
        url = "https://code.videolan.org/videolan/vlc/-/commit/795b1bc62be58ee1636c1fac28330d02bc0e08e0.patch";
        hash = "sha256-JQRlOpJd8D28H3UZy0CTquMfN4zBJuOq2eczdX/5+Oo=";
      })
    ];
  });
in lib.mkMerge [
    (lib.mkIf cfg.usePatchedVlc vlcPatched)
    (lib.mkIf (!cfg.usePatchedVlc) pkgs.vlc)
];
in {
  options.viv = {
    usePatchedVlc = lib.mkOption {
      type= lib.types.bool;
      description= "whether to use a patched version of vlc as a workaround for very wide subtitles";
      default= false;
    };
  };

  config = {
    environment.systemPackages = [ vlc ];
  };
}
