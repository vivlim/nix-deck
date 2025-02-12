{ pkgs, ... }:
{
  systemd.services.glances-web = {
    description = "glances webserver";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.glances}/bin/glances -w";
    };
  };
}
