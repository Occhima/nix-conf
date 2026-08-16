{
  flake.modules.homeManager.foliate = {
    programs.foliate.enable = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/epub+zip" = [ "com.github.johnfactotum.Foliate.desktop" ];
        "application/x-mobipocket-ebook" = [ "com.github.johnfactotum.Foliate.desktop" ];
        "application/vnd.amazon.mobi8-ebook" = [ "com.github.johnfactotum.Foliate.desktop" ];
        "application/x-fictionbook+xml" = [ "com.github.johnfactotum.Foliate.desktop" ];
        "application/x-zip-compressed-fb2" = [ "com.github.johnfactotum.Foliate.desktop" ];
        "x-scheme-handler/opds" = [ "com.github.johnfactotum.Foliate.desktop" ];
      };
    };
  };
}
