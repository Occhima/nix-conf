{ config, inputs, ... }:
let
  aiAssets = config.flake.lib.custom.aiAssets;
in
{
  flake-file.inputs.oh-my-pi = {
    url = "github:can1357/oh-my-pi";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.pi =
    { pkgs, ... }:
    {
      imports = [ inputs.oh-my-pi.homeManagerModules.default ];

      programs.omp = {
        enable = true;
        settings = {
          theme.dark = "titanium";
          startup.quiet = true;
          tools = {
            approvalMode = "write";
            approval.bash = "prompt";
          };
        };
      };

      # omp reads its user-level context natively from `~/.omp/agent/AGENTS.md`;
      # the module itself exposes no `context` option for it.
      home.file.".omp/agent/AGENTS.md".source = aiAssets.agentsMd;

      programs.pi-coding-agent = {
        enable = true;
        context = aiAssets.agentsMd;
        extraPackages = [
          pkgs.nodejs
          pkgs.bun
        ];
        settings = {
          theme = "dark";
          compaction = {
            enabled = true;
            reserveTokens = 16384;
            keepRecentTokens = 20000;
          };
          retry = {
            enabled = true;
            maxRetries = 3;
          };
        };
      };

      programs.git.ignores = [
        ".omp/"
        ".pi/"
      ];
    };
}
