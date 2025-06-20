{
  modules = {
    network = {
      enable = true;
      hostName = "integration-test";
      networkmanager.enable = true;
      firewall.enable = false;
    };

    virtualisation.vm = {
      enable = true;
      memorySize = 512;
      diskSize = 1024;
    };
  };
}
