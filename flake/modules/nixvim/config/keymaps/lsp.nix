{ ... }:
{
  plugins.lsp.keymaps = {
    silent = true;
    lspBuf = {
      K = {
        action = "hover";
        desc = "Show docs";
      };
      gd = {
        action = "definition";
        desc = "Go to definition";
      };
      gD = {
        action = "declaration";
        desc = "Go to declaration";
      };
      gi = {
        action = "implementation";
        desc = "Go to implementation";
      };
      gt = {
        action = "type_definition";
        desc = "Go to type definition";
      };
      ga = {
        action = "code_action";
        desc = "Code action";
      };
      "g*" = {
        action = "document_symbol";
        desc = "Document symbols";
      };
      "<leader>lr" = {
        action = "rename";
        desc = "Rename symbol";
      };
      "<leader>lf" = {
        action = "format";
        desc = "Format buffer";
      };
    };
    diagnostic = {
      "<leader>ld" = {
        action = "setloclist";
        desc = "Diagnostics list";
      };
    };
  };
}
