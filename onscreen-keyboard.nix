{ modulesPath, config, lib, pkgs, ... }: let

# Shell script which invokes gsettings with the schemas for maliit-keyboard set.
schema-path = "${pkgs.maliit-keyboard}/share/gsettings-schemas/maliit-keyboard-2.3.1/glib-2.0/schemas"; # todo: derivation that just gets the schema path inside of this. right now it hardcodes the kb version...
gsettings-maliit = pkgs.writeShellScriptBin "gsettings-maliit" ''
# usage suggestion: gsettings-maliit list-recursively
env GSETTINGS_SCHEMA_DIR=$GSETTINGS_SCHEMA_DIR:${schema-path} ${pkgs.glib.bin}/bin/gsettings "$@"
'';

dconf-editor-maliit = pkgs.writeShellScriptBin "dconf-editor-maliit" ''
env GSETTINGS_SCHEMA_DIR=$GSETTINGS_SCHEMA_DIR:${schema-path} ${pkgs.dconf-editor}/bin/dconf-editor ${schema-path} --I-understand-that-changing-options-can-break-applications "$@"
'';

maliit-apply-viv-settings = pkgs.writeShellScriptBin "maliit-apply-viv-settings" ''
# these don't seem to really work yet
${gsettings-maliit}/bin/gsettings-maliit set org.maliit.keyboard.maliit auto-capitalization false
${gsettings-maliit}/bin/gsettings-maliit set org.maliit.keyboard.maliit opacity 0.7
${gsettings-maliit}/bin/gsettings-maliit set org.maliit.keyboard.maliit plugin-paths ${pkgs.maliit-keyboard}/lib/maliit/plugins # gsettings can only set an entire array at once, put in quotes and quare brackets and single quotes

'';

in {
  environment.systemPackages = with pkgs; [
    maliit-keyboard # onscreen keyboard, integrates with plasma nicely
    maliit-framework
    gsettings-maliit
    dconf-editor-maliit
  ];

  system.activationScripts.configureMaliit = pkgs.lib.stringAfter [ "var" ] ''
  # todo apply some settings here? if it makes sense to do it globally?
  '';
}

