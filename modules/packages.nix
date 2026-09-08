{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    blesh
    exiftool
    tldr
    devbox
    deno
    xmake
    httpie
    android-tools

    (writeShellScriptBin "nixup" ''
      cd ${config.home.homeDirectory}/.config/home-manager && nix flake update
    '')
  ];
}
