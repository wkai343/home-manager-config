{ ... }:
{
  home.shellAliases = {
    ff = "fastfetch";
  };

  programs.bash = {
    enable = true;

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
}
