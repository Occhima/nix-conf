{ ... }:
{
  config.occhima.discord.homeManager = (
    {
      config,
      ...
    }:
    {
      config = {
        programs.vesktop = {
          enable = true;
          settings = {
            appBadge = false;
            arRPC = true;
            disableMinSize = true;
            minimizeToTray = false;
            tray = false;
            hardwareAcceleration = true;
            discordBranch = "stable";
          };

          vencord.settings = {
            autoUpdate = true;
            autoUpdateNotification = false;
            disableMinSize = true;
            notifyAboutUpdates = false;
            plugins = {
              AlwaysTrust.enabled = true;
              BlurNSFW.enabled = true;
              ClearURLs.enabled = true;
              FakeNitro.enabled = true;
              PinDMs.enabled = true;
              WebKeybinds.enabled = true;
              WebScreenShareFixes.enabled = true;
            };
            useQuickCss = true;
          };
        };
      };
    }
  );
}
