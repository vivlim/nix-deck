{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.prometheus_exporters;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.prometheus_exporters = {
    enable = mkEnableOption (lib.mdDoc "Some prometheus exporters to replace netdata with");

    nodeArgs = mkOption {
      type = types.str;
      default = "--collector.systemd --collector.processes";
      description = "Extra command-line args for node_exporter";
    };
    nodePort = mkOption {
      type = types.port;
      default = 19990;
      description = lib.mdDoc "Which port to host node metrics on";
    };

    systemdArgs = mkOption {
      type = types.str;
      default = "--systemd.collector.enable-restart-count --systemd.collector.enable-ip-accounting";
      description = "Extra command-line args for systemd_exporter";
    };
    systemdPort = mkOption {
      type = types.port;
      default = 19991;
      description = lib.mdDoc "Which port to host systemd metrics on";
    };

    combinedPort = mkOption {
      type = types.port;
      default = 19999;
      description = lib.mdDoc "Which port to host combined metrics on";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.prometheus_exporters_node = {
      description = "prometheus exporter for node (machine) stats";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.prometheus-node-exporter}/bin/node_exporter --web.listen-address=\":${toString cfg.nodePort}\" ${cfg.nodeArgs}";
      };
    };

    systemd.services.prometheus_exporters_systemd = {
      description = "prometheus exporter for systemd stats";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.prometheus-systemd-exporter}/bin/systemd_exporter --web.listen-address=\":${toString cfg.systemdPort}\" ${cfg.systemdArgs}";
      };
    };

    systemd.services.prometheus_exporters_combined = let
      exporterExporterPkg = pkgs.buildGoModule rec {
        pname = "exporter_exporter";
        version = "0.4.5";
        rev = "v${version}";
        src = pkgs.fetchFromGitHub {
          inherit rev;
          owner = "QubitProducts";
          repo = "exporter_exporter";
          sha256 = "sha256-+ea7lNIZsk6ShLLqg+x1MQOP6GKYxD16+97efWVQPGA=";
        };

        vendorSha256 = "sha256-kTw4g3D3MrrsOfPSWswyvTuU8KNdKBoMMmruOoL/Pio=";

        meta = with lib; {
          description = "prometheus exporter for prometheus exporter(s)";
        };
      };

      config = pkgs.writeText "expexp.yml" ''
      modules:
        node:
          method: http
          http:
            port: ${toString cfg.nodePort}
        systemd:
          method: http
          http:
            port: ${toString cfg.systemdPort}
      '';
    in {
      description = "prometheus exporter combining the others";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${exporterExporterPkg}/bin/exporter_exporter --config.file ${config} --web.listen-address=\":${toString cfg.combinedPort}\" ";
      };
    };
  };
}
