{ pkgs }:

with pkgs; [
  # General packages for development and system management
  coreutils
  neofetch
  openssh
  wget
  zip
  gnumake
  imagemagick
  lld
  baobab
  typst
  nixd
  nil

  # Encryption and security tools
  age
  gnupg

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  ffmpeg
  fd

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # but i also like bun ;)
  bun

  # Fonts
  jetbrains-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.meslo-lg
  
  # Text and terminal utilities
  ripgrep
  tree
  tmux
  unrar
  unzip
  zsh-powerlevel10k

  # Python packages
  python3
  virtualenv

  # Rust + Cargo
  rustc
  cargo

  # Gradle
  gradle

  # Go
  go
  go-task

  # Java (Malheuresement)
  jdk

  # To test
  lazygit
  lazydocker

  # Cyber
  exegol 

  tamarin-prover
]
