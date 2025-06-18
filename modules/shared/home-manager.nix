{ config, pkgs, lib, ... }:

let name = "Luca Mandrelli";
    user = "lmandrelli";
    email = "luca.mandrelli@icloud.com"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    cdpath = [ "~/.local/share/src" ];
    plugins = [
      {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./config;
          file = "p10k.zsh";
      }
    ];
    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi
      
      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.cargo/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Ripgrep alias
      alias search=rg -p --glob '!node_modules/*'  $@

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # pnpm is a javascript package manager
      alias pn=pnpm
      alias px=pnpx

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';
  };

  git = {
    enable = true;
    userName = name;
    userEmail = email;
    lfs.enable = true;

    ignores = [
      # direnv
      ".direnv"
      ".envrc"

      # Linux
      "*~"
      ".fuse_hidden*"
      ".directory" 
      ".Trash-*"
      ".nfs*"

      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
      "*.icloud"

      # VSCode
      ".vscode/*"
      "!.vscode/settings.json"
      "!.vscode/tasks.json"
      "!.vscode/launch.json"
      "!.vscode/extensions.json"
      "!.vscode/*.code-snippets"
      ".history/"
      "*.vsix"
      ".history"
      ".ionide"

      # Nix
      "result"
      "result-*"
      ".direnv/"
      ".pre-commit-config.yaml"
      "flake.lock"

      # Zed
      ".zed/"

      # Editor/IDE
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"
      ".*.sw[a-z]"

      # Tags
      "TAGS"
      ".TAGS"
      "!TAGS/"
      "tags"
      ".tags"
      "!tags/"
      "gtags.files"
      "GTAGS"
      "GRTAGS"
      "GPATH"
      "GSYMS"
      "cscope.files"
      "cscope.out"
      "cscope.in.out"
      "cscope.po.out"

      # Roo Code
      ".roo"
      ".roorules"
    ];

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "zed";
        autocrlf = "input";
      };
      pull.rebase = false;
      rebase.autoStash = true;
      push.autoSetupRemote = true;
    };
  };

  ssh = {
    enable = true;
  };

  direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        # Enable nix-direnv manual reload mode system-wide
        nix_direnv_manual_reload = true;
      };
    };
  };
}
