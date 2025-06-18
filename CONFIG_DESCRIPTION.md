# 📋 Description de la Configuration Nix

Cette documentation décrit le rôle de chaque fichier dans cette configuration Nix multi-plateforme (macOS/NixOS).

## 🔄 Mise à Jour Majeure - NixOS Reconfigurée

**La configuration NixOS a été complètement reconfigurée :**
- ✅ **NixOS 25.05** (version stable)
- ✅ **Hyprland** au lieu de bspwm/polybar
- ✅ **Drivers Nvidia open-source**
- ✅ **Applications équivalentes aux casks macOS**
- ✅ **Configuration basique et moderne**

## 🏗️ Fichiers Racine

### [`flake.nix`](flake.nix)
**Point d'entrée principal** de la configuration. Définit :
- Les inputs (dépendances) : nixpkgs, home-manager, nix-darwin, disko, etc.
- Les outputs pour chaque système (darwinConfigurations, nixosConfigurations)
- Les applications (scripts) disponibles par architecture
- La configuration multi-plateforme (x86_64/aarch64 pour Linux/macOS)

### [`flake.lock`](flake.lock)
**Fichier de verrouillage** généré automatiquement qui fixe les versions exactes de toutes les dépendances pour garantir la reproductibilité.

### [`README.md`](README.md)
**Documentation complète** avec instructions d'installation pour macOS et NixOS, guide d'utilisation, et explications des fonctionnalités.

## 🖥️ Hosts - Configurations par Système

### [`hosts/darwin/default.nix`](hosts/darwin/default.nix)
**Configuration principale macOS** avec nix-darwin :
- Configuration Nix (cache, garbage collection, experimental features)
- Préférences système macOS (dock, finder, trackpad, clavier)
- Scripts d'activation (désactivation du son de démarrage)
- Import des modules partagés et spécifiques à Darwin

### [`hosts/nixos/default.nix`](hosts/nixos/default.nix)
**Configuration principale NixOS** (reconfigurée) :
- Configuration bootloader (systemd-boot)
- **Hyprland** : Compositeur Wayland moderne
- **Drivers Nvidia open-source** activés
- **PipeWire** : Audio moderne (ALSA/PulseAudio/JACK)
- **NetworkManager** : Gestion réseau simplifiée
- **Greetd** : Display manager minimal
- Configuration utilisateurs et SSH
- Support matériel Nvidia optimisé

## 📁 Modules - Configuration Modulaire

### 🍎 Modules Darwin (macOS)

#### [`modules/darwin/packages.nix`](modules/darwin/packages.nix)
**Liste des packages Nix** spécifiques à macOS. Importe les packages partagés et ajoute `dockutil`.

#### [`modules/darwin/casks.nix`](modules/darwin/casks.nix)
**Applications Homebrew Cask** organisées par catégories :
- Développement : Docker, VSCode, Zed, Warp, MongoDB Compass
- Communication : Discord, Zoom, Spotify  
- Productivité : Raycast, Microsoft Office, Obsidian
- Navigateurs : Chrome, Firefox, Orion
- Design : Affinity Suite, Figma, SF Symbols
- Utilitaires : Audacity, OBS, Wireshark

#### [`modules/darwin/home-manager.nix`](modules/darwin/home-manager.nix)
**Configuration utilisateur macOS** avec Home Manager :
- Définition de l'utilisateur système
- Configuration Homebrew (casks et Mac App Store)
- Configuration du dock déclaratif avec applications et dossiers
- Import des fichiers partagés et spécifiques

#### [`modules/darwin/files.nix`](modules/darwin/files.nix)
**Fichiers de configuration statiques** spécifiques à macOS (actuellement vide).

#### [`modules/darwin/dock/default.nix`](modules/darwin/dock/default.nix)
**Module personnalisé pour gestion déclarative du dock** :
- Options pour activer/configurer le dock
- Types pour définir les entrées (path, section, options)
- Script d'activation qui synchronise le dock avec la configuration
- Utilise `dockutil` pour manipuler le dock programmatiquement

### 🐧 Modules NixOS

#### [`modules/nixos/packages.nix`](modules/nixos/packages.nix)
**Applications équivalentes aux casks macOS** :
- **Développement** : VSCode, Zed, Docker, MongoDB Compass, Warp Terminal
- **Communication** : Discord, Zoom, Spotify
- **Navigateurs** : Firefox, Chrome
- **Productivité** : LibreOffice, Obsidian, Thunderbird, Bitwarden
- **Multimédia** : VLC, OBS Studio, Audacity, Handbrake
- **Graphisme** : GIMP, Inkscape, Figma Linux
- **Écosystème Hyprland** : Waybar, Mako, Rofi-Wayland, Hyprpaper
- **Outils système** : Grim/Slurp (screenshots), Pavucontrol, NetworkManager

#### [`modules/nixos/home-manager.nix`](modules/nixos/home-manager.nix)
**Configuration utilisateur NixOS avec Hyprland** :
- **Configuration Hyprland** : Compositeur Wayland avec animations
- **Waybar** : Barre de statut moderne pour Wayland
- **Mako** : Système de notifications
- **Rofi-Wayland** : Lanceur d'applications
- **Thème GTK** : Adwaita-dark pour cohérence
- Import des configurations partagées

#### [`modules/nixos/files.nix`](modules/nixos/files.nix)
**Configuration Hyprland et styles** :
- **hyprland.conf** : Raccourcis clavier, paramètres de fenêtrage
- **style.css** : Styles CSS pour Waybar
- Configuration des contrôles système (volume, luminosité, screenshots)

#### [`hosts/nixos/hardware-configuration.nix`](hosts/nixos/hardware-configuration.nix)
**Configuration matérielle** (à générer/adapter) :
- Modules kernel et drivers
- Points de montage des systèmes de fichiers
- Configuration CPU (Intel/AMD)
- Template à personnaliser selon votre matériel

### 🔗 Modules Partagés

#### [`modules/shared/default.nix`](modules/shared/default.nix)
**Configuration nixpkgs commune** :
- Permissions (allowUnfree, allowBroken)
- Auto-import des overlays depuis le dossier overlays/

#### [`modules/shared/packages.nix`](modules/shared/packages.nix)
**Packages installés sur toutes les plateformes** :
- Utilitaires système : coreutils, wget, zip, openssh
- Développement : docker, nodejs, python, rust, go, java
- Terminal : ripgrep, tmux, tree, zsh-powerlevel10k
- Sécurité : age, gnupg
- Fonts : jetbrains-mono, nerd-fonts
- Outils spécialisés : lazygit, exegol, tamarin-prover

#### [`modules/shared/home-manager.nix`](modules/shared/home-manager.nix)
**Configuration utilisateur partagée** (le cœur de la config) :
- **Zsh** : Shell principal avec Powerlevel10k, aliases, PATH personnalisé
- **Git** : Configuration utilisateur, ignores globaux, hooks
- **Vim** : Configuration complète avec plugins et mappings
- **Tmux** : Multiplexeur terminal avec plugins et navigation vim
- **Direnv** : Chargement automatique d'environnements
- **SSH** : Configuration client SSH

#### [`modules/shared/files.nix`](modules/shared/files.nix)
**Fichiers statiques partagés** (actuellement vide).

#### [`modules/shared/config/p10k.zsh`](modules/shared/config/p10k.zsh)
**Configuration Powerlevel10k** pour le prompt Zsh :
- Segments gauche : dir, vcs, context, execution_time, virtualenv, prompt_char
- Segments droite : nix_shell avec nom
- Couleurs et icônes personnalisées
- Formatter Git personnalisé
- Configuration pour nix-shell

## 🎭 Overlays

### [`overlays/10-feather-font.nix`](overlays/10-feather-font.nix)
**Overlay personnalisé** qui ajoute la police Feather Icons :
- Télécharge et installe la police d'icônes Feather
- Utilisée par polybar pour les icônes dans l'interface

### [`overlays/README.md`](overlays/README.md)
**Documentation** expliquant l'usage des overlays (patches, versions personnalisées, workarounds).

## 🚀 Applications (Scripts)

### [`apps/`](apps/)
**Scripts d'automation** organisés par architecture :

#### Scripts Darwin (macOS)
- **`apply`** : Applique la configuration sans switch
- **`build`** : Construit la configuration 
- **`build-switch`** : Construit et active la configuration
- **`rollback`** : Retour à la génération précédente
- **`copy-keys`**, **`create-keys`**, **`check-keys`** : Gestion des clés SSH

#### Scripts Linux (NixOS)
- **`apply`** : Applique la configuration système
- **`build-switch`** : Construit et active (équivalent nixos-rebuild)
- **`install`** : Installation initiale du système
- **`copy-keys`**, **`create-keys`**, **`check-keys`** : Gestion des clés SSH

## 🔄 Flux de Configuration

1. **[`flake.nix`](flake.nix)** → Point d'entrée, définit les systèmes
2. **[`hosts/*/default.nix`](hosts/)** → Configuration système spécifique
3. **[`modules/shared/default.nix`](modules/shared/default.nix)** → Importé par tous les systèmes
4. **[`modules/*/packages.nix`](modules/)** → Packages par plateforme
5. **[`modules/*/home-manager.nix`](modules/)** → Configuration utilisateur
6. **[`modules/shared/home-manager.nix`](modules/shared/home-manager.nix)** → Config utilisateur partagée
7. **[`overlays/`](overlays/)** → Auto-importés pour personnalisations

## 🎯 Utilisation

- **macOS** : `nix run .#build-switch` (depuis le répertoire)
- **NixOS** : `sudo nix run github:user/repo#install` (installation initiale)
- **Développement** : Scripts dans `apps/` pour différentes opérations
- **Personnalisation** : Modifier les fichiers dans `modules/` selon vos besoins

Cette architecture modulaire permet une maintenance facile et une réutilisation maximale du code entre plateformes.