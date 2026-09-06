{ ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
      # 界面
      number = true;
      # relativenumber = true;
      cursorline = true;
      signcolumn = "yes";
      termguicolors = true;

      # tab缩进
      tabstop = 4;
      shiftwidth = 0;
      expandtab = true;

      # 自动更新
      autoread = true;

      # # 搜索
      # ignorecase = true;
      # smartcase = true;
      # hlsearch = true;
      # incsearch = true;

    };
  };
}
