{ config, pkgs, ... }:

let
  dataDir = "${config.xdg.dataHome}/vaultwarden";
in
{
  systemd.user.services.vaultwarden = {
    Unit.Description = "Vaultwarden password manager";

    Service = {
      ExecStart = "${pkgs.vaultwarden}/bin/vaultwarden";
      Restart = "on-failure";
      RestartSec = 5;
      UMask = "0077";

      Environment = [
        "DATA_FOLDER=${dataDir}"
        "WEB_VAULT_FOLDER=${pkgs.vaultwarden.webvault}/share/vaultwarden/vault"
        "WEB_VAULT_ENABLED=true"
        "ROCKET_ADDRESS=127.0.0.1"
        "ROCKET_PORT=8222"
        "DOMAIN=https://vault.qwq233.top"
        "SIGNUPS_ALLOWED=true"
      ];
    };

    Install.WantedBy = [ "default.target" ];
  };

  home.activation.vaultwardenDataDir =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "${dataDir}"
      run chmod 700 "${dataDir}"
    '';
}
