{
  description = "Home Manager configuration of wk";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable";
    home-manager.url = "git+https://git.nju.edu.cn/nix-mirror/home-manager.git";
    nixvim.url = "git+https://git.nju.edu.cn/nix-mirror/nixvim.git";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";
      # system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."wk" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          nixvim.homeModules.nixvim
          ./home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
