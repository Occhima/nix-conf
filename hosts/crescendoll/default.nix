{
  config = {

    modules = {
      secrets = {
        yubikey = {
          enable = true;
          containsAgeKeys = true;
          enableSudo = false;
        };
        agenix = {
          enable = true;
          secretsDir = ../secrets;
          identityPaths = [ ../secrets/identity/yubi-identity.txt ];
        };

      };
    };
  };

}
