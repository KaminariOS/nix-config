# Generated via dconf2nix: https://github.com/kaminari/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "standard";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      default-sort-order = "type";
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };
  };
}
