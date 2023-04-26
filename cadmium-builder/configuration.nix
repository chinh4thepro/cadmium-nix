{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./scripts.nix
    ];

  hardware = {
    opengl = {
      driSupport32Bit = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio = {
      enable = false;
    };
  };

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
    hostName = "nixked";
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
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          fcitx5-table-other
          fcitx5-configtool
        ];
      };
    };
  };

  services = {
    xserver = {
      enable = false;
      displayManager.sddm.enable = false;
      desktopManager.plasma5.enable = false;
      # layout = "us";
      # xkbVariant = "";
      # libinput.enable = true;
    };
    printing = {
      enable = true;
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
    gvfs = {
      enable = true;
    };
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    tlp = {
      enable = true;
    };
    auto-cpufreq = {
      enable = true;
    };
    logind = {
      lidSwitch = "suspend";
      extraConfig = ''
        HandlePowerKey = ignore
        '';
      };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    waybar = {
      enable = true;
    };
    steam = {
      enable = true;
    };
    mtr = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
    };
    dconf = {
      enable = true;
    };
    sway = {
      enable = true;
    };
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  security = {
    doas = {
      enable = true;
      extraRules = [{
        users = [ "chinh4thepro" ];
	keepEnv = true;
	noPass = true;
      }];
    };
    sudo = {
      enable = false;
    };
    rtkit = {
      enable = true;
    };
    polkit = {
      enable = true;
    };
  };

  users.users.chinh4thepro = {
    isNormalUser = true;
    description = "chinh4thepro";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "audio" "video" "network" "nix" "lp" "power" "systemd-journal" "input" ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];
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

    # Shell
    nushell

    # Text
    neovim
    vscodium
    helix
    
    # Desktop utilities
    swaylock-effects
    swayidle
    xdg-desktop-portal-hyprland
    dunst
    wl-clipboard
    slurp
    grim
    wofi
    tofi
    brightnessctl
    waybar
    swww
    cinnamon.nemo
    gnome.file-roller
    dconf
    gnome.dconf-editor
    libsForQt5.spectacle
    
    # Terminal
    kitty

    # Audio
    pulseaudio

    # Misc
    neofetch
    fzf
    android-tools
    
    # Internet
    networkmanagerapplet
    librewolf
    ungoogled-chromium
    discord
    thunderbird
    curl
    wget

    # Music
    spotify
    spotifywm
    spotify-tray

    # Media
    mpv
    ani-cli
    vlc
    imv

    # VMs
    spice
    virt-manager
    libguestfs
    libvirt

    # Gaming
    prismlauncher
    grapejuice

    # Theming
    lxappearance
    gsettings-desktop-schemas
    gnome.adwaita-icon-theme
    adwaita-qt
    adwaita-qt6
    libadwaita
    gnome2.GConf
    orchis-theme
    wpgtk

    # Coding
    rustup
    gcc
    glib
    jdk
    nodejs
    openjdk

    # Proton stuff
    protonvpn-gui
    protonvpn-cli

    # Polkit
    polkit_gnome

    # CLI tools
    killall
    duf
    wgetpaste
    btop

  ];

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  systemd = {
    services = {
      seatd = {
        enable = true;
        description = "Seat management daemon";
        script = "${pkgs.seatd}/bin/seatd -g wheel";
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "1";
        };
        wantedBy = ["multi-user.target"];
      };
      NetworkManager-wait-online = {
        enable = false;
      };
    };
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      font-awesome
      fantasque-sans-mono
    ];
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
