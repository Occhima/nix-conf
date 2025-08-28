{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  # inherit (lib.custom) hasProfile;
  cfg = config.modules.shell.cli;
in
# configuredAiSupport = hasProfile config [ "ai" ];

{
  config = mkIf (cfg.enable && builtins.elem "pay-respects" cfg.tools) {
    programs.pay-respects = {
      enable = true;
      # alias = "F";
      # aiIntegration = configuredAiSupport;
    };
  };
}
