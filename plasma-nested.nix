{ modulesPath, config, lib, pkgs, ... }: let

plasma-nested = pkgs.writeShellScriptBin "plasma-nested" ''
unset LD_PRELOAD
unset XDG_DESKTOP_PORTAL_DIR
unset XDG_SEAT_PATH
unset XDG_SESSION_PATH
RES=$(${pkgs.xorg.xdpyinfo}/bin/xdpyinfo | awk '/dimensions/{print $2}')

## Shadow kwin_wayland_wrapper so that we can pass args to kwin wrapper 
## whilst being launched by plasma-session

mkdir $XDG_RUNTIME_DIR/nested_kde -p
cat <<EOF > $XDG_RUNTIME_DIR/nested_kde/kwin_wayland_wrapper
#!/bin/sh
${pkgs.kwin}/bin/kwin_wayland_wrapper --width $(echo "$RES" | cut -d 'x' -f 1) --height $(echo "$RES" | cut -d 'x' -f 2) --no-lockscreen \$@
EOF
chmod a+x $XDG_RUNTIME_DIR/nested_kde/kwin_wayland_wrapper
export PATH=$XDG_RUNTIME_DIR/nested_kde:$PATH

dbus-run-session startplasma-wayland
rm $XDG_RUNTIME_DIR/nested_kde/kwin_wayland_wrapper
'';

in {
  environment.systemPackages = with pkgs; [
    plasma-nested
  ];
}

