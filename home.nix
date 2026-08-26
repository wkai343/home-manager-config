{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wk";
  home.homeDirectory = "/home/wk";

  targets.genericLinux.enable = true;
  #nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/610.57.04/NVIDIA-Linux-x86_64-610.57.04.run
  # targets.genericLinux.gpu.nvidia = {
  #   enable = true;
  #   version = "610.57.04";
  #   sha256 = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
  # };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.shellAliases = {
    ff = "fastfetch";
  };
  
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
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

    (writeShellScriptBin "nixup" ''
      cd /home/wk/.config/home-manager && nix flake update
    '')
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/wk/etc/profile.d/hm-session-vars.sh
  #
  # 登录时（.profile）生效
  # home.sessionVariables = {
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.bash = {
    enable = true;

    # bashrcExtra = ''
      
    # '';

    initExtra = ''
      [[ $- == *i* ]] && source -- "$(blesh-share)"/ble.sh --attach=none

      # Source global definitions
      if [ -f /etc/bashrc ]; then
          . /etc/bashrc
      fi

      # User specific environment
      if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
          PATH="$HOME/.local/bin:$HOME/bin:$PATH"
      fi
      export PATH

      export PROMPT_END=" \\ \\t\n"
      export PROMPT_SEPARATOR=" \\ "
      export EDITOR="vim"
      export PATH="/home/wk/.local/share/pnpm/bin:/home/wk/.moon/bin:/home/wk/.deno/bin:$PATH"

      if [[ -r "$HOME/.config/secret/openai.env" ]]; then
        source "$HOME/.config/secret/openai.env"
      fi
      
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };

  programs.uv.enable = true;

  programs.direnv = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.prismlauncher = {
    enable = true;
  };

  services.tldr-update = {
    enable = true;
    period = "weekly";
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "wk";
        email = "58632380+wkai343@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.codex = {
    enable = true;
    settings = {
      model = "gpt-5.6-sol";
      model_reasoning_effort = "xhigh";
      model_provider = "jcg";
      model_providers = {
        jcg = {
          name = "OpenAI";
          base_url = "https://ai-pixel.online/v1";
          env_key = "OPENAI_API_KEY";
        };
      };
      sandbox_mode = "workspace-write";
      approval_policy = "on-request";
    };
    # profiles = {
    #   default = {
    #     model = "gpt-5.6-sol";
    #     model_reasoning_effort = "max";
    #     approval_policy = "on-request";
    #     sandbox_mode = "workspace-write";
    #   };
    # };
  };

  # programs.codexDesktopLinux = {
  #   enable = true;
  #   cliPackage = pkgs.codex;

  #   linuxFeatures = [
  #     "frameless-titlebar"
  #     "open-target-discovery"
  #     "mcp-helper-reaper"
  #     "node-repl-reaper"
  #     "persistent-status-panel"
  #     "ui-tweaks"
  #   ];
  # };

}
