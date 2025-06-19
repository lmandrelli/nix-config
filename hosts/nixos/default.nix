{ config, pkgs, inputs, ... }:

let user = "lmandrelli"; in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/shared
  ];

  # Lanzaboote for Secure Boot + TPM2
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # Use the systemd-boot EFI boot loader (disabled when using lanzaboote)
  boot = {
    loader = {
      systemd-boot.enable = false; # Disabled for lanzaboote
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages;
    
    # LUKS with TPM2 support - Update the UUID to match your encrypted device
    # To find your LUKS UUID, run: lsblk -f
    initrd.luks.devices."luks-root" = {
      device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";
      crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-pcrs=0+2+7" ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Localization settings for France
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Networking
  networking = {
    hostName = "nixos-supernova"; # Define your hostname.
    networkmanager.enable = true; # Enable NetworkManager
  };

  # Nix configuration
  nix = {
    settings = {
      allowed-users = [ "${user}" ];
      trusted-users = [ "@admin" "${user}" ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Support TPM2
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  # Enable Hyprland with specific package
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # Ensure portal package is in sync with Hyprland package
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # XDG portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["hyprland" "gtk"];
      };
      hyprland = {
        default = ["hyprland" "gtk"];
      };
    };
  };

  # Graphics and hardware - CRITICAL for RTX 5070
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    # OBLIGATOIRE pour RTX 5070
    nvidia = {
      open = true;  # REQUIS - driver open kernel
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Video drivers
  services.xserver.videoDrivers = ["nvidia"];

  # Variables d'environnement pour Wayland/NVIDIA
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Audio PipeWire (disable PulseAudio)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Programs
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    # Gaming Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };

  # Services
  services = {
    openssh.enable = true;
    printing.enable = true;
    
    # GNOME avec Wayland (obligatoire)
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;  # FORCER Wayland pour GNOME
      };
      desktopManager.gnome.enable = true;
      # Configuration clavier français
      xkb = {
        layout = "fr";
        variant = "";
      };
    };
    
    # Hyprland comme session par défaut
    displayManager.defaultSession = "hyprland";
  };

  # Console keyboard layout
  console.keyMap = "fr";

  # Users
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable 'sudo' for the user.
        "networkmanager"
        "audio"
        "video"
      ];
      shell = pkgs.zsh;
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
  ];

  # Basic system packages
  environment.systemPackages = with pkgs; [
    gitAndTools.gitFull
    inetutils
    zed-editor
    gamemode
    mangohud
  ];

  # Éditeur par défaut
  environment.variables.EDITOR = "zed";

  system.stateVersion = "25.05";
}
