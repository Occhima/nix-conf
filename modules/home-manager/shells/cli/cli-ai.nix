{ occhima, ... }:
{
  config.occhima.cli-ai.includes = with occhima; [
      claude-code
      opencode
      aider
      fabric
      jcode
      codegraph
      feynman
    ];
}
