{ ... }:
{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        section_separators = {
          left = "";
          right = "";
        };
        component_separators = {
          left = "│";
          right = "│";
        };
        disabled_filetypes.statusline = [ "dashboard" "alpha" ];
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" "diff" "diagnostics" ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            path = 1;
            shorting_target = 40;
          }
        ];
        lualine_x = [ "filetype" ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      inactive_sections = {
        lualine_c = [ "filename" ];
        lualine_x = [ "location" ];
      };
    };
  };

  plugins.dashboard = {
    enable = true;
    settings = {
      theme = "doom";
      config = {
        header = [
          ""
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
          ""
        ];
        center = [
          {
            action = "Telescope find_files";
            desc = " Find File";
            icon = " ";
            key = "f";
          }
          {
            action = "Telescope oldfiles";
            desc = " Recent Files";
            icon = "󰄉 ";
            key = "r";
          }
          {
            action = "Telescope live_grep";
            desc = " Find Text";
            icon = " ";
            key = "g";
          }
          {
            action = "Neogit";
            desc = " Git";
            icon = " ";
            key = "G";
          }
          {
            action = "qa";
            desc = " Quit";
            icon = "󰅚 ";
            key = "q";
          }
        ];
        footer = [ ];
      };
    };
  };

  plugins.noice = {
    enable = true;
    settings = {
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
        signature.enabled = false;
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        lsp_doc_border = true;
      };
    };
  };

  plugins.indent-blankline = {
    enable = true;
    settings.indent.char = "¦";
  };
}
