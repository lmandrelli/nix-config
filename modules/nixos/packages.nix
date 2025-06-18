{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # Development Tools
  docker
  docker-compose
  vscode
  mongodb-compass
  zed-editor
  warp-terminal
  kitty
  
  # Communication Tools
  discord
  zoom-us
  spotify

  # Entertainment Tools
  vlc
  steam
  wine

  # Productivity Tools
  libreoffice  # Microsoft Office alternative
  obsidian

  # Browsers
  google-chrome
  firefox

  # Graphic tools
  inkscape
  gimp
  figma-linux

  # Utilities
  audacity
  handbrake
  obs-studio
  ollama
  wireshark

  # Additional Linux-specific utilities
  gparted
  neofetch
  tree
  unzip
  zip
  
  # Media and graphics
  mpv
  feh
    
  # Office and productivity extras
  thunderbird
  bitwarden-desktop

  # Hyprland ecosystem
  waybar
  mako
  rofi-wayland
  hyprpaper
  grim
  slurp
  wl-clipboard
  brightnessctl
  pavucontrol
  networkmanagerapplet
  blueman
  thunar
  
  # System tools
  htop
  btop
  
]
