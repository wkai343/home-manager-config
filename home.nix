{ ... }:
{
  imports = [
    ./modules/nixpkgs.nix
    ./modules/packages.nix
    ./modules/programs/bash.nix
    ./modules/programs/bat.nix
    ./modules/programs/direnv.nix
    ./modules/programs/eza.nix
    ./modules/programs/fd.nix
    ./modules/programs/fzf.nix
    ./modules/programs/git.nix
    ./modules/programs/home-manager.nix
    ./modules/programs/jq.nix
    ./modules/programs/nixvim.nix
    ./modules/programs/ripgrep.nix
    ./modules/programs/uv.nix
    ./modules/programs/yazi.nix
    ./modules/programs/zoxide.nix
    ./modules/services/openlist.nix
    ./modules/services/tldr-update.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wk";
  home.homeDirectory = "/home/wk";
  home.stateVersion = "26.05";
}
