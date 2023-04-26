{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };

  networking = {
    hostName = "cadmium-builder";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
    };
  };

  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  services = {
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      layout = "us";
      xkbVariant = "";
      libinput.enable = true;
    };
    openssh = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  programs = {
    mtr = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  security = {
    sudo = {
      enable = true;
    };
    rtkit = {
      enable = true;
    };
    polkit = {
      enable = true;
    };
  };

  users.users.builder = {
    isNormalUser = true;
    description = "builder";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "audio" "video" "network" "nix" "lp" "power" "systemd-journal" "input" ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 6d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [

    # Stuff for building cadmium


  ];

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  systemd = {
    services = {
      NetworkManager-wait-online = {
        enable = false;
      };
    };
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
