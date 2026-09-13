{ pkgs, ... }:

let
  mkService = command: {
    Unit.Description = "RustDesk ${command}";

    Service = {
      ExecStart = "${pkgs.rustdesk-server}/bin/${command}";
      WorkingDirectory = "%S/rustdesk-server";
      StateDirectory = "rustdesk-server";
      StateDirectoryMode = "0700";
      UMask = "0077";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install.WantedBy = [ "default.target" ];
  };
in
{
  systemd.user.services = {
    rustdesk-hbbs = mkService "hbbs";
    rustdesk-hbbr = mkService "hbbr";
  };
}