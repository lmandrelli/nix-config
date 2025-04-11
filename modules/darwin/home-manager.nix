{ config, pkgs, lib, home-manager, ... }:

let
  user = "lmandrelli";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)

    masApps = {
     
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = { 
    dock = {
      enable = true;
      entries = [
        { path = "/Applications/Bitwarden.app"; }
        { path = "/Applications/Safari.app"; }
        { path = "/Applications/Firefox.app"; }
        { path = "/Applications/Orion.app"; }
        { path = "/Applications/Discord.app"; }
        { path = "/System/Applications/Music.app/"; }
        { path = "/System/Applications/Home.app/"; }
        { path = "/Applications/Microsoft Word.app"; }
        { path = "/Applications/Microsoft Excel.app"; }
        { path = "/Applications/Microsoft Powerpoint.app"; }
        { path = "/Applications/Affinity Designer 2.app"; }
        { path = "/Applications/Affinity Photo 2.app"; }
        { path = "/Applications/Luminar Neo.app"; }
        { path = "/Applications/Visual Studio Code.app"; }
        { path = "/Applications/Zed.app"; }
        { path = "/Applications/Tabby.app"; }
        { path = "/Applications/Warp.app"; }
        {
          path = "/Users/lmandrelli";
          section = "others";
          options = "--sort name --view list --display folder";
        }
        {
          path = "/Users/lmandrelli/Downloads";
          section = "others";
          options = "--sort name --view fan --display folder";
        }
        {
          path = "/Applications";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
      ];
    };
  };
}
