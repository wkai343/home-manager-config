{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    blesh
    exiftool
    tldr
    devbox
    deno
    nodejs
    pnpm
    xmake
    httpie
    jetbrains.clion
    jetbrains.idea
    reqable
    microsoft-edge
    osu-lazer-bin
    scrcpy
    android-tools
    looking-glass-client

    (writeShellScriptBin "nixup" ''
      cd ${config.home.homeDirectory}/.config/home-manager && nix flake update
    '')
  ];
}
