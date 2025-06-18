# 🐧 Installation NixOS avec Hyprland

Cette configuration NixOS a été complètement reconfigurée pour utiliser Hyprland avec les drivers Nvidia open-source et NixOS 25.05.

## 📋 Prérequis

- Clé USB bootable avec NixOS 25.05
- PC avec carte graphique Nvidia
- Connexion Internet

## 🚀 Installation

### 1. Booter sur NixOS Live

Téléchargez et bootez sur l'ISO NixOS 25.05 minimal.

### 2. Partitionnement

Partitionnez votre disque manuellement. Exemple pour `/dev/sda` :

```bash
# Créer les partitions
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary 512MB 100%

# Formatter les partitions
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

# Monter les partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

### 3. Générer la configuration hardware

```bash
nixos-generate-config --root /mnt
```

### 4. Cloner cette configuration

```bash
nix-shell -p git
cd /mnt/etc/nixos
git clone https://github.com/votre-username/nix-config .
```

### 5. Adapter la configuration hardware

Copiez le contenu généré de `/mnt/etc/nixos/hardware-configuration.nix` vers `hosts/nixos/hardware-configuration.nix` dans cette configuration.

### 6. Modifier les paramètres utilisateur

Dans `flake.nix`, modifiez :
```nix
user = "votre-nom-utilisateur";
```

Dans `hosts/nixos/default.nix`, ajustez :
- Le hostname si désiré
- Les clés SSH si nécessaire

### 7. Installation

```bash
nixos-install --flake .#x86_64-linux
```

### 8. Redémarrer et configurer

Après redémarrage :
- Connectez-vous en tant que root
- Définissez le mot de passe utilisateur : `passwd votre-nom-utilisateur`
- Redémarrez et connectez-vous avec votre utilisateur

## ✨ Fonctionnalités Incluses

### 🎮 Interface Graphique
- **Hyprland** : Compositeur Wayland moderne
- **Waybar** : Barre de statut
- **Mako** : Notifications
- **Rofi** : Lanceur d'applications
- **Hyprpaper** : Gestionnaire de fond d'écran

### 🖥️ Applications Équivalentes aux Casks macOS
- **Développement** : VSCode, Zed, Docker, MongoDB Compass, Warp Terminal
- **Communication** : Discord, Zoom, Spotify
- **Navigateurs** : Firefox, Chrome
- **Productivité** : LibreOffice, Obsidian, Thunderbird, Bitwarden
- **Multimédia** : VLC, OBS Studio, Audacity, Handbrake
- **Graphisme** : GIMP, Inkscape, Figma Linux

### 🔧 Outils Système
- **Audio** : PipeWire avec support ALSA/PulseAudio/JACK
- **Réseau** : NetworkManager avec applet
- **Bluetooth** : Blueman
- **Screenshots** : Grim + Slurp
- **Contrôles** : Pavucontrol, brightnessctl

### 🎯 Configuration GPU Nvidia
- Drivers open-source Nvidia
- Support Wayland optimisé
- Accélération matérielle activée

## ⌨️ Raccourcis Hyprland de Base

- `Super + Q` : Terminal (Kitty)
- `Super + C` : Fermer fenêtre
- `Super + E` : Gestionnaire de fichiers
- `Super + R` : Lanceur d'applications
- `Super + V` : Mode flottant
- `Super + F` : Plein écran
- `Super + 1-9` : Changer d'espace de travail
- `Super + Shift + 1-9` : Déplacer fenêtre vers espace

## 🔧 Personnalisation

### Modifier la configuration Hyprland
Éditez `modules/nixos/files.nix` pour personnaliser les raccourcis et paramètres.

### Ajouter des applications
Ajoutez des packages dans `modules/nixos/packages.nix`.

### Appliquer les changements
```bash
sudo nixos-rebuild switch --flake .#x86_64-linux
```

## 🆘 Dépannage

### Problèmes Nvidia
Si vous rencontrez des problèmes avec Nvidia, essayez :
```nix
# Dans hosts/nixos/default.nix, changez :
hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
# au lieu de .beta
```

### Performance Hyprland
Pour améliorer les performances, ajustez dans la config Hyprland :
```
decoration {
  blur {
    enabled = false
  }
}
```

Cette configuration offre un environnement de bureau moderne et fonctionnel avec toutes les applications équivalentes à votre setup macOS !