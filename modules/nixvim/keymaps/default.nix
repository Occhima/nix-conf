{
  imports = [
    ./ai.nix
    ./buffers.nix
    ./files.nix
    ./git.nix
    ./lsp.nix
  ];

  plugins.which-key = {
    enable = true;
    settings = {
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "files";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "git";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "lsp";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "buffers";
          icon = "󰓩 ";
        }
        {
          __unkeyed-1 = "<leader>a";
          group = "ai";
          icon = "󰚩 ";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "refactor";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>w";
          proxy = "<C-w>";
          group = "windows";
          icon = " ";
        }
      ];
      plugins.spelling.enabled = false;
    };
  };

  keymaps = [
    # Escape insert mode
    {
      mode = "i";
      key = "jj";
      action = "<Esc>";
      options.silent = true;
    }

    # Clear search highlight
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = {
        silent = true;
        desc = "Clear search highlight";
      };
    }

    # Diagnostics navigation
    {
      mode = "n";
      key = "ge";
      action.__raw = "vim.diagnostic.goto_next";
      options.desc = "Next diagnostic";
    }
    {
      mode = "n";
      key = "gE";
      action.__raw = "vim.diagnostic.goto_prev";
      options.desc = "Prev diagnostic";
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "Show diagnostic";
    }

    # Spell suggest via telescope
    {
      mode = "n";
      key = "z=";
      action = "<cmd>Telescope spell_suggest<CR>";
      options.desc = "Spell suggest";
    }

    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Window left";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Window down";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Window up";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Window right";
    }

    # Refactoring
    {
      mode = "n";
      key = "<leader>rr";
      action.__raw = ''require("telescope").extensions.refactoring.refactors'';
      options.desc = "Select refactor";
    }
    {
      mode = "n";
      key = "<leader>re";
      action = ":Refactor extract_var ";
      options.desc = "Extract variable";
    }
    {
      mode = "n";
      key = "<leader>rE";
      action = ":Refactor extract ";
      options.desc = "Extract function";
    }
    {
      mode = "n";
      key = "<leader>rb";
      action = ":Refactor extract_block ";
      options.desc = "Extract block";
    }
    {
      mode = "n";
      key = "<leader>ri";
      action = ":Refactor inline_var ";
      options.desc = "Inline variable";
    }
    {
      mode = "n";
      key = "<leader>rI";
      action = ":Refactor inline_func ";
      options.desc = "Inline function";
    }
  ];
}
