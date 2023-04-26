{ config, pkgs, ... }:

{
  home = {

    username = "runner";
    homeDirectory = "/home/runner";
    stateVersion = "22.11";
    
    packages = with pkgs; [

      # Stuff to build cadmium


    ];

    pointerCursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
    };
  };
}
