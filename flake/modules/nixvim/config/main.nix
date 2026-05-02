{ ... }:
{
  viAlias = true;
  vimAlias = true;

  luaLoader.enable = true;
  editorconfig.enable = true;

  plugins = {
    comment.enable = true;
    todo-comments.enable = true;
    web-devicons.enable = true;

    refactoring = {
      enable = false;
      enableTelescope = true;
    };

    mini = {
      enable = true;
      modules = {
        surround = { };
        trailspace = { };
      };
    };

    nvim-autopairs.enable = true;
    luasnip.enable = true;
    tmux-navigator.enable = true;
    bufdelete.enable = true;
  };
}
