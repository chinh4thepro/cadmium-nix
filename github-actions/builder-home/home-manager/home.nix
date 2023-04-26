{ config, pkgs, ... }:

{
    home = {
      username = "runner";
      homeDirectory = "/home/runner";
      stateVersion = "22.11";
    
      packages = with pkgs; [

      # Stuff to build cadmium
      binutils
      gcc
      gcc-arm-embedded
      libtool
      libarchive
      curl
      wget
      f2fs-tools
      vboot_reference
      ncurses
      gawk
      flex
      bison
      openssl
      libelf
      libudev-zero
      libiberty
      autoconf
      qemu_full
      qemu-utils
      debootstrap
      proot
      ubootTools
      lz4
      git
      arch-install-scripts

      ];

    programs = {
      home-manager = {
        enable = true;
      };
      git = {
        enable = true;
      };
    };
  };
}
