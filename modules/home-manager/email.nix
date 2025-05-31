{ config, lib, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.modules.email;
in
{
  options.modules.email = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable email configuration";
    };
  };

  config = mkIf cfg.enable {
    accounts.email = {
      maildirBasePath = "${config.home.homeDirectory}/maildir";
      accounts = {
        usp = {
          primary = true;
          address = "marcoocchialini@usp.br";
          realName = "Marco Occhialini";
          userName = "marcoocchialini@usp.br";
          flavor = "gmail.com";
          # passwordCommand = "${pkgs.pass}/bin/pass Email/usp.br/marcoocchialini";

          # IMAP configuration
          # imap = {
          #   host = "imap.usp.br";
          #   port = 993;
          #   tls.enable = true;
          # };

          # SMTP configuration
          # smtp = {
          #   host = "smtp.usp.br";
          #   port = 587;
          #   tls.enable = true;
          # };

          # Enable mbsync for maildir syncing
          # mbsync = {
          #   enable = true;
          #   create = "maildir";
          #   remove = "none";
          #   expunge = "both";
          # };

          # Enable mu indexing
          # mu.enable = true;

          # Maildir configuration
          maildir.path = "usp";
        };

        personal = {
          address = "marcoocchialini@hotmail.com";
          realName = "Marco Occhialini";
          userName = "marcoocchialini@hotmail.com";
          # passwordCommand = "${pkgs.pass}/bin/pass Email/hotmail.com/marcoocchialini";
          flavor = "outlook.office365.com";

          # IMAP configuration for Outlook/Hotmail
          # imap = {
          #   host = "outlook.office365.com";
          #   port = 993;
          #   tls.enable = true;
          # };

          # SMTP configuration for Outlook/Hotmail
          # smtp = {
          #   host = "smtp.office365.com";
          #   port = 587;
          #   tls.enable = true;
          # };

          # Enable mbsync for maildir syncing
          # mbsync = {
          #   enable = true;
          #   create = "maildir";
          #   remove = "none";
          #   expunge = "none";
          # };

          # Enable mu indexing
          mu.enable = true;

          # Maildir configuration
          maildir.path = "personal";
        };

        gmail = {
          address = "marcoocchialini2@gmail.com";
          realName = "Marco Occhialini";
          userName = "marcoocchialini2@gmail.com";

          flavor = "gmail.com";

          maildir.path = "gmail";

          mu.enable = true;

          mbsync = {
            enable = true;
            create = "maildir";
            remove = "none";
            expunge = "both";
            groups.gmail.channels = {
              inbox = {
                farPattern = "";
                nearPattern = "inbox";
                extraConfig = {
                  Create = "Near";
                  CopyArrivalDate = "yes";
                  MaxMessages = 1000000;
                  MaxSize = "10m";
                  Sync = "All";
                  SyncState = "*";
                  Expunge = "Both";
                };
              };
              trash = {
                farPattern = "[Gmail]/Trash";
                nearPattern = "trash";
                extraConfig = {
                  Create = "Near";
                  CopyArrivalDate = "yes";
                  MaxMessages = 1000000;
                  MaxSize = "10m";
                  Sync = "All";
                  SyncState = "*";
                };
              };
              sent = {
                farPattern = "[Gmail]/Sent Mail";
                nearPattern = "sent";
                extraConfig = {
                  Create = "Near";
                  CopyArrivalDate = "yes";
                  MaxMessages = 1000000;
                  MaxSize = "10m";
                  Sync = "All";
                  SyncState = "*";
                  Expunge = "Both";
                };
              };
              archive = {
                farPattern = "[Gmail]/All Mail";
                nearPattern = "archive";
                extraConfig = {
                  Create = "Near";
                  CopyArrivalDate = "yes";
                  MaxMessages = 1000000;
                  MaxSize = "10m";
                  Sync = "All";
                  SyncState = "*";
                };
              };
              drafts = {
                farPattern = "[Gmail]/Drafts";
                nearPattern = "drafts";
                extraConfig = {
                  Create = "Near";
                  CopyArrivalDate = "yes";
                  MaxMessages = 1000000;
                  MaxSize = "10m";
                  Sync = "All";
                  SyncState = "*";
                  Expunge = "Both";
                };
              };
            };
          };
        };
      };
    };

    # Enable mu and mbsync
    # programs.mu.enable = true;
    # programs.mbsync.enable = true;

    # Enable mbsync service to regularly sync emails
    # services.mbsync = {
    #   enable = true;
    #   frequency = "*:0/15"; # Every 15 minutes
    # };

    # Install password-store for password retrieval
    # programs.password-store.enable = true;
  };
}
