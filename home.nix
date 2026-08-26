{ ... }:
{
  imports = [
    ./modules/nixpkgs.nix
    ./modules/packages.nix
    ./modules/programs/bash.nix
    ./modules/programs/codex.nix
    ./modules/programs/direnv.nix
    ./modules/programs/eza.nix
    ./modules/programs/fd.nix
    ./modules/programs/fzf.nix
    ./modules/programs/git.nix
    ./modules/programs/home-manager.nix
    ./modules/programs/jq.nix
    ./modules/programs/neovim.nix
    ./modules/programs/prismlauncher.nix
    ./modules/programs/ripgrep.nix
    ./modules/programs/uv.nix
    ./modules/programs/yazi.nix
    ./modules/programs/zoxide.nix
    ./modules/services/tldr-update.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wk";
  home.homeDirectory = "/home/wk";
  home.stateVersion = "26.05";

  targets.genericLinux.enable = true;
  #nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/610.57.04/NVIDIA-Linux-x86_64-610.57.04.run
  # targets.genericLinux.gpu.nvidia = {
  #   enable = true;
  #   version = "610.57.04";
  #   sha256 = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
  # };
}
