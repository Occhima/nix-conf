{
  flake.modules.homeManager.fzf = { pkgs, ... }: {
    config = {
      programs.fzf = {
        enable = true;

        defaultOptions = [
          "--height 40%"
          "--layout=reverse"
          "--border"
          "--inline-info"
          "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
          "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
          "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
        ];

        # Atuin (sourced after fzf) owns Ctrl-R; disable fzf's history widget.
        historyWidget.command = "";

        fileWidget.options = [
          "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:500 {}'"
        ];

        changeDirWidget.options = [
          "--preview '${pkgs.eza}/bin/eza --tree --level=2 --color=always {}'"
        ];
      };
    };
  };
}
