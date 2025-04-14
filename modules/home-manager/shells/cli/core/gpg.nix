{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;

in

{
  # GPG is always enabled as a core tool
  config = {
    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
      settings = {
        keyserver = "keys.openpgp.org";

        # Security and cryptographic preferences
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";

        # Display preferences
        charset = "utf-8";
        fixed-list-mode = "";
        no-comments = "";
        no-emit-version = "";
        no-greeting = "";
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = "";

        # Security features
        require-cross-certification = "";
        no-symkey-cache = "";
        use-agent = "";
        armor = "";
        throw-keyids = "";
      };
    };

    # GPG agent enabled when cli module is enabled
    services.gpg-agent = mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      enableSshSupport = true;
      enableScDaemon = true;
      pinentryPackage = pkgs.pinentry-curses;
      extraConfig = "allow-preset-passphrase";
    };

  };
}
