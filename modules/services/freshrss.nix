{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Open http://127.0.0.1:8080 and finish the SQLite installation in the browser.
  port = 8080;
  dataDir = "${config.xdg.dataHome}/freshrss";
  freshrss = pkgs.freshrss;
  php = pkgs.php.buildEnv {
    extraConfig = ''
      date.timezone = Asia/Shanghai
      session.save_path = "${dataDir}/sessions"
      sys_temp_dir = "${dataDir}/tmp"
      curl.cainfo = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      openssl.cafile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    '';
  };

  environment = [
    "DATA_PATH=${dataDir}"
    "TMPDIR=${dataDir}/tmp"
    "FRESHRSS_SOCKET=%t/freshrss/php-fpm.sock"
  ];

  prepare = pkgs.writeShellScript "freshrss-prepare" ''
    set -eu
    ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArgs [ dataDir "${dataDir}/sessions" "${dataDir}/tmp" ]}
    ${php}/bin/php ${freshrss}/cli/prepare.php
  '';

  fpmConfig = pkgs.writeText "freshrss-php-fpm.conf" ''
    [global]
    ; Use syslog: systemd's journal socket cannot be reopened as a file.
    error_log = syslog
    syslog.ident = freshrss-phpfpm
    daemonize = no

    [freshrss]
    listen = ''${FRESHRSS_SOCKET}
    listen.mode = 0600
    pm = ondemand
    pm.max_children = 4
    pm.process_idle_timeout = 10s
    pm.max_requests = 500
    catch_workers_output = yes
    decorate_workers_output = no
    clear_env = yes
    env[DATA_PATH] = ${dataDir}
    env[TMPDIR] = ${dataDir}/tmp
  '';

  caddyConfig = pkgs.writeText "freshrss-Caddyfile" ''
    {
      admin off
      persist_config off
      auto_https off
    }

    http://:${toString port} {
      bind 127.0.0.1
      # Only the public directory is served; the database stays outside it.
      root * ${freshrss}/p
      php_fastcgi unix/{$FRESHRSS_SOCKET}
      file_server
      encode gzip
    }
  '';

  commonService = {
    Environment = environment;
    UMask = "0077";
  };
in
{
  systemd.user.services = {
    freshrss-init = {
      Unit.Description = "Prepare FreshRSS data directories";
      Service = commonService // {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${prepare}";
      };
    };

    freshrss-phpfpm = {
      Unit = {
        Description = "FreshRSS PHP-FPM";
        Requires = [ "freshrss-init.service" ];
        After = [ "freshrss-init.service" ];
      };
      Service = commonService // {
        Type = "notify";
        ExecStart = "${php}/bin/php-fpm --nodaemonize --fpm-config ${fpmConfig}";
        RuntimeDirectory = "freshrss";
        RuntimeDirectoryMode = "0700";
        Restart = "on-failure";
        RestartSec = 5;
        KillSignal = "SIGQUIT";
      };
      Install.WantedBy = [ "default.target" ];
    };

    freshrss = {
      Unit = {
        Description = "FreshRSS web server";
        Wants = [ "freshrss-phpfpm.service" ];
        After = [ "freshrss-phpfpm.service" ];
      };
      Service = commonService // {
        ExecStart = "${pkgs.caddy}/bin/caddy run --config ${caddyConfig} --adapter caddyfile";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };

    freshrss-refresh = {
      Unit = {
        Description = "Refresh FreshRSS feeds";
        Requires = [ "freshrss-init.service" ];
        After = [ "freshrss-init.service" ];
        # Wait until the browser installation has created the configuration.
        ConditionPathExists = "${dataDir}/config.php";
      };
      Service = commonService // {
        Type = "oneshot";
        ExecStart = "${php}/bin/php ${freshrss}/app/actualize_script.php";
        TimeoutStartSec = "30min";
      };
    };
  };

  systemd.user.timers.freshrss-refresh = {
    Unit.Description = "Refresh FreshRSS feeds every 30 minutes";
    Timer = {
      OnCalendar = "*-*-* *:00,30:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
