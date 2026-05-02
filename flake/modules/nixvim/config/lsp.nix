{ ... }:
{
  plugins.lsp = {
    enable = true;
    inlayHints = true;

    servers = {
      bashls.enable = true;
      lua_ls.enable = true;
      ruff.enable = true;
      pyright = {
        enable = true;
        settings = {
          pyright.disableOrganizeImports = true;
          python.analysis.ignore = [ "*" ];
        };
      };
      nixd = {
        enable = true;
        settings.nixpkgs.expr = "import <nixpkgs> { }";
      };
      hls = {
        enable = true;
        installGhc = true;
      };
      ccls.enable = true;
      gopls.enable = true;
      ts_ls.enable = true;
      zls.enable = true;
      rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };
    };
  };

  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        lsp_format = "fallback";
        timeout_ms = 500;
      };
      formatters_by_ft = {
        nix = [ "nixfmt" ];
        python = [ "ruff_format" ];
        rust = [ "rustfmt" ];
        lua = [ "stylua" ];
        javascript = [ "prettierd" "prettier" ];
        typescript = [ "prettierd" "prettier" ];
        json = [ "prettierd" "prettier" ];
        yaml = [ "prettierd" "prettier" ];
        markdown = [ "prettierd" "prettier" ];
        sh = [ "shfmt" ];
      };
    };
  };
}
