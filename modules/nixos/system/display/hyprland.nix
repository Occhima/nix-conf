{
  flake.modules.nixos.display-hyprland = {
    programs.hyprland.enable = true;
    environment.etc."greetd/environments".text = "Hyprland";
  };
}
