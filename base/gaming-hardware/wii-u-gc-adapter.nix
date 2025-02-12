{ pkgs, lib, ... }:
let
wii-u-gc-adapter = 
  pkgs.stdenv.mkDerivation rec {
    pname = "wii-u-gc-adapter";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "ToadKing";
      repo = pname;
      rev = "master";
      sha256 = "sha256-wm0vDU7QckFvpgI50PG4/elgPEkfr8xTmroz8kE6QMo=";
    };

    strictDeps = true;
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.libusb1 pkgs.udev ] ;

    preBuild = ''
    echo "the cflags: $CFLAGS"
    echo "the makefile:"
    cat Makefile
    '';
    postPatch = ''
    substituteInPlace Makefile --replace "-Wno-format" ""
    '';

    # makefile doesn't provide a install target
    installPhase = ''
    mkdir -p $out/bin
    cp wii-u-gc-adapter $out/bin
    '';

    dontConfigure = true;

    makeFlags = [ "DESTDIR=${placeholder "out"}" ];

    meta = with lib; {
      homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
      description = "yep";
      platforms = platforms.linux;
      license = licenses.mit;
    };
  };
in
{
  environment.systemPackages = [
    wii-u-gc-adapter 
  ];

  services.udev.extraRules = ''
    # udev rule for user access to wii-u-gc-adapter device
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0660", TAG+="uaccess"
    # allow logged-in users to access /dev/uinput (need to log back in for this to take effect, probably)
    KERNEL=="uinput", TAG+="uaccess"
  '';
}

