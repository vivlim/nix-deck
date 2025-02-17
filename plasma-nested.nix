{ modulesPath, config, lib, pkgs, ... }: let

plasma-nested = pkgs.writeShellScriptBin "plasma-nested" ''
echo "env before unsetting anything"
printenv

unset LD_PRELOAD
unset XDG_DESKTOP_PORTAL_DIR
unset XDG_SEAT_PATH
unset XDG_SESSION_PATH
unset DBUS_SESSION_BUS_ADDRESS
RES=$(${pkgs.xorg.xdpyinfo}/bin/xdpyinfo | awk '/dimensions/{print $2}')

echo "starting at $(date)" >> /home/vivlim/plasma-nested.log

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
plasma-nested-systemd-cat = pkgs.writeShellScriptBin "plasma-nested" ''
  systemd-cat --identifier=plasma-nested --priority=info --stderr-priority=warning ${plasma-nested}/bin/plasma-nested
'';
plasma-nested-desktop-item = pkgs.makeDesktopItem { # Inside of a explicit derivation I could probably just assign this to the list `desktopItems` but right now i'm just using a simple shell script, so it's a separate package
  name = "plasma-nested";
  desktopName = "Plasma (nested)";
  genericName = "A nested plasma environment";
  exec = "${plasma-nested-systemd-cat}/bin/plasma-nested";
};
in {
  environment.systemPackages = with pkgs; [
    plasma-nested-systemd-cat
    plasma-nested-desktop-item
  ];
}

