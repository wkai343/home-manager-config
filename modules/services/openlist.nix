{
  config,
  pkgs,
  lib,
  ...
}:

let
  dataDir = "${config.xdg.dataHome}/openlist";
in
{
  home.packages = [ pkgs.openlist ];

  systemd.user.services.openlist = {
    Unit = {
      Description = "OpenList file list program";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.openlist} server --data ${dataDir}";
      WorkingDirectory = dataDir;
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # 确保数据目录存在
  home.activation.openlistDataDir = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "${dataDir}"
  '';
}
