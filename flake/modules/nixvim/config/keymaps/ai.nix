{ ... }:
{
  # Avante keymaps are configured via plugins.avante.settings.mappings in ai.nix.
  # This file registers the which-key group so <leader>a shows in the popup.
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>aa";
      desc = "Ask AI";
    }
    {
      __unkeyed-1 = "<leader>ae";
      desc = "Edit with AI";
    }
    {
      __unkeyed-1 = "<leader>ar";
      desc = "Refresh AI";
    }
    {
      __unkeyed-1 = "<leader>af";
      desc = "Focus AI";
    }
    {
      __unkeyed-1 = "<leader>at";
      desc = "Toggle AI";
    }
  ];
}
