# Guernica asset paths, published for sibling contributors (targets live a
# directory down and consume these through the fixed point).
{
  flake.lib.guernica.assets = {
    wallpapers = ./assets/wallpapers;
    wallpaper = ./assets/wallpapers/guernica.jpg;
  };
}
