{
  config = {
    networking.hostName = "crescendoll";
    modules = {
      profiles = {
        enable = true;
        active = [
          "wsl"
        ];
      };
    };
  };
}
