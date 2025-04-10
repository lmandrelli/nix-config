{ pkgs }:

with pkgs; [
  # General packages for development and system management
  coreutils
  neofetch
  openssh
  wget
  zip
  gnumake

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

  # Text and terminal utilities
  jetbrains-mono
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

  # To test
  lazygit
  lazydocker
]
