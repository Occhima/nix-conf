{ ... }:
{
  config.occhima.ssh.homeManager = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          settings."*" = {
            HashKnownHosts = true;
            Compression = true;
          };

          # TODO...
          # settings."github.com" = mkIf hasAgeKeys {
          #   User = "git";
          #   HostName = "github.com";
          #   IdentityFile = osConfig.age.secrets.github.path;
          # };
        };
      };
    }
  );
}
