# Complete Guide: Applying This NixOS Configuration to a Fresh Installation

This comprehensive guide will walk you through applying this advanced NixOS flake configuration to a freshly installed NixOS system. This configuration includes Hyprland, Secure Boot with lanzaboote, Home Manager, and extensive application packages.

## Prerequisites

- A freshly installed NixOS system using the graphical installer
- Internet connection
- Basic familiarity with terminal commands
- Understanding that this will completely replace your current configuration

## Configuration Features

This configuration provides:
- **Hyprland**: Modern Wayland compositor with beautiful animations
- **Secure Boot**: TPM2 and lanzaboote integration  
- **Home Manager**: Declarative user environment management
- **French Localization**: System configured for France (timezone, keyboard, locale)
- **NVIDIA Support**: Optimized for RTX graphics cards with open-source drivers
- **Modern Development Environment**: Zed editor, development tools, terminal setup
- **Gaming Support**: Steam with Gamescope session

## Step 1: Verify Your Fresh Installation

After installing NixOS with the graphical installer, ensure you have:

```bash
# Check you're running NixOS
cat /etc/os-release | grep "NAME=NixOS"

# Check nix flakes are enabled (may not be by default)
nix --version
```

## Step 2: Enable Nix Flakes (If Not Already Enabled)

If flakes aren't enabled, temporarily enable them:

```bash
# Enable flakes for this session
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Or enable system-wide by editing configuration.nix
sudo nano /etc/nixos/configuration.nix
```

Add this to your configuration.nix if needed:
```nix
nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
};
```

Then rebuild: `sudo nixos-rebuild switch`

## Step 3: Clone This Configuration

```bash
# Clone this repository to your system
git clone https://github.com/yourusername/nixos-config.git /tmp/nixos-config
cd /tmp/nixos-config

# Make the apply script executable
chmod +x apps/x86_64-linux/apply
```

## Step 4: Generate New Hardware Configuration

Generate hardware configuration for your specific system:

```bash
# Generate hardware configuration for your system
sudo nixos-generate-config --root /mnt

# Copy the generated hardware configuration
sudo cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/nixos/hardware-configuration.nix
```

**Important**: Edit `hosts/nixos/hardware-configuration.nix` and verify:
- Correct disk UUIDs for your system
- Proper filesystem types
- Network interface names

## Step 5: Customize Your Configuration

### 5.1 Update User Information

Run the configuration script to personalize the setup:

```bash
# This will prompt for your details and update configuration files
./apps/x86_64-linux/apply
```

This script will ask for:
- Your username
- Email address
- Full name
- GitHub username (for secrets repo if using)
- System hostname

### 5.2 Update Hardware-Specific Settings

Edit `hosts/nixos/default.nix` to match your system:

```bash
sudo nano hosts/nixos/default.nix
```

Key items to verify/update:
- **User variable** (line 3): Should match your username
- **Hostname** (line 51): Set your desired hostname  
- **Timezone** (line 33): Currently set to "Europe/Paris"
- **LUKS UUID** (line 27): Update with your encrypted disk UUID if using encryption
- **NVIDIA settings**: Verify driver package matches your GPU
- **Locale settings** (lines 36-47): Currently set for France

### 5.3 Configure Secure Boot (Optional but Recommended)

If you want Secure Boot support:

```bash
# Create secure boot directory
sudo mkdir -p /etc/secureboot

# The lanzaboote configuration is already in the flake
# You'll need to enroll keys after first boot
```

### 5.4 Update Package Selection

Review and customize packages in:
- `modules/nixos/packages.nix` - NixOS-specific packages
- `modules/shared/packages.nix` - Cross-platform packages

## Step 6: Copy Configuration to System

```bash
# Backup existing configuration
sudo cp -r /etc/nixos /etc/nixos.backup

# Copy new configuration
sudo cp -r . /etc/nixos/

# Ensure correct ownership
sudo chown -R root:root /etc/nixos
```

## Step 7: Build and Test Configuration

Before switching, build the configuration to check for errors:

```bash
cd /etc/nixos

# Build without switching (test)
sudo nixos-rebuild build --flake .#x86_64-linux

# If build succeeds, you can continue
```

## Step 8: Apply the Configuration

**Warning**: This will replace your entire system configuration.

```bash
# Switch to the new configuration
sudo nixos-rebuild switch --flake .#x86_64-linux
```

This process may take 30-60 minutes depending on your internet connection, as it will download:
- Hyprland and Wayland components
- Development tools and applications
- NVIDIA drivers
- Home Manager and user packages

## Step 9: Post-Installation Setup

### 9.1 Set User Password

```bash
# Set password for your user
sudo passwd yourusername
```

### 9.2 Reboot and Verify

```bash
# Reboot to new system
sudo reboot
```

After reboot:
1. You should see GDM login manager
2. Choose Hyprland session from session menu
3. Log in with your user account

### 9.3 Verify Hyprland Setup

After logging into Hyprland:
- `Super + Q` - Open terminal (Kitty)
- `Super + R` - Open application launcher (Wofi)  
- `Super + E` - Open file manager (Nautilus)

### 9.4 Complete Secure Boot Setup (If Enabled)

```bash
# Generate and enroll secure boot keys
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft

# Sign the kernel
sudo sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI

# Enable secure boot in BIOS/UEFI
```

## Step 10: Apply Future Updates

To update your system in the future:

```bash
# Navigate to config directory
cd /etc/nixos

# Update flake inputs
sudo nix flake update

# Rebuild and switch
sudo nixos-rebuild switch --flake .#x86_64-linux
```

## Troubleshooting

### Build Errors

1. **GPU Driver Issues**: If you have different GPU, edit `hosts/nixos/default.nix` line 121
2. **Locale Issues**: Verify timezone and locale settings in `hosts/nixos/default.nix`
3. **Missing Hardware**: Check `hardware-configuration.nix` for correct disk UUIDs

### Boot Issues

1. **Secure Boot**: Disable in BIOS temporarily if having boot issues
2. **LUKS**: Update LUKS UUID in configuration if using disk encryption
3. **GRUB**: Check boot loader configuration in `hosts/nixos/default.nix`

### Home Manager Issues

```bash
# Check Home Manager status
systemctl status home-manager-yourusername.service

# Rebuild Home Manager manually
home-manager switch --flake /etc/nixos#yourusername@nixos
```

### Network Issues

```bash
# Check NetworkManager status
systemctl status NetworkManager

# Restart networking
sudo systemctl restart NetworkManager
```

## Key Shortcuts (Hyprland)

- `Super + Q` - Terminal
- `Super + C` - Close window  
- `Super + E` - File manager
- `Super + R` - App launcher
- `Super + V` - Toggle floating
- `Super + F` - Fullscreen
- `Super + 1-9` - Switch workspace
- `Super + Shift + 1-9` - Move window to workspace
- `Super + H/J/K/L` - Navigate windows (Vim-style)
- `Print` - Screenshot area
- `Super + Print` - Full screenshot

## Applications Included

### Development
- Zed editor (default)
- VSCode
- Git with configuration
- Docker
- Various development tools

### Internet & Communication  
- Firefox browser
- Email clients
- Communication tools

### Gaming
- Steam with Gamescope
- Game optimization tools

### System Tools
- Network management
- Audio control (PipeWire)
- Bluetooth management
- System monitoring

## Configuration Management

- **System config**: `/etc/nixos/`
- **User config**: Managed by Home Manager
- **Dotfiles**: Defined in `modules/shared/files.nix`
- **Package management**: Declarative via Nix files

## Security Features

- **Secure Boot**: lanzaboote integration
- **TPM2**: Hardware security module support  
- **Encrypted storage**: LUKS configuration ready
- **Firewall**: Configured automatically

This configuration provides a modern, secure, and fully-featured NixOS system optimized for development work with a beautiful Hyprland desktop environment.