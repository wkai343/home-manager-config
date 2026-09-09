{ config, pkgs, ... }:

let
  postgresql = pkgs.postgresql_18;
  dataDir = "${config.xdg.dataHome}/postgresql/";
in
{
  systemd.user.services.postgresql = {
    Unit.Description = "PostgreSQL database server";

    Service = {
      Type = "simple";

      ExecStart = "${postgresql}/bin/postgres -D ${dataDir} -h 127.0.0.1 -k ${dataDir}";
      ExecReload = "${postgresql}/bin/pg_ctl -D ${dataDir} reload";

      Restart = "on-failure";
      RestartSec = 5;

      KillSignal = "SIGINT";
      KillMode = "mixed";
      TimeoutStopSec = "infinity";

      UMask = "0077";
    };

    Install.WantedBy = [ "default.target" ];
  };
}