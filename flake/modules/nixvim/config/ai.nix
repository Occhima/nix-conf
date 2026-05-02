{ ... }:
{
  plugins.avante = {
    enable = true;
    settings = {
      provider = "claude";
      claude = {
        model = "claude-sonnet-4-6";
        max_tokens = 8192;
        temperature = 0;
      };
      behaviour = {
        auto_suggestions = false;
        auto_set_highlight_group = true;
        auto_set_keymaps = true;
        auto_apply_diff_after_generation = false;
      };
      windows = {
        position = "right";
        wrap = true;
        width = 40;
      };
      mappings = {
        ask = "<leader>aa";
        edit = "<leader>ae";
        refresh = "<leader>ar";
        focus = "<leader>af";
        toggle.default = "<leader>at";
        diff = {
          next = "]x";
          prev = "[x";
        };
      };
    };
  };
}
