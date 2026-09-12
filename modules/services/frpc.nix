{ config, pkgs, ... }:

let
  frp = pkgs.frp;
  configFile = "${config.xdg.configHome}/frp/frpc.toml";
in
{
  systemd.user.services.frpc = {
    Unit.Description = "frp client";

    Service = {
      Type = "simple";
      ExecStart = "${frp}/bin/frpc -c ${configFile}";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
