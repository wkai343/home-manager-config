{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "idea"
      "reqable"
      "clion"
      "libwemeetwrap"
      "wemeet"
      "microsoft-edge"
      "osu-lazer-bin"
      "nvidia-x11"
    ];

  nixpkgs.config.nvidia.acceptLicense = true;
}
