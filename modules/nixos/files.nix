{ user, ... }:

let
  home = "/home/${user}";
  xdg_configHome = "${home}/.config";
in
{
  # Hyprland configuration file
  "${xdg_configHome}/hypr/hyprland.conf" = {
    text = ''
      # Keybindings
      $mainMod = SUPER

      # Basic bindings
      bind = $mainMod, Q, exec, kitty
      bind = $mainMod, C, killactive
      bind = $mainMod, M, exit
      bind = $mainMod, E, exec, thunar
      bind = $mainMod, V, togglefloating
      bind = $mainMod, R, exec, rofi -show drun
      bind = $mainMod, P, pseudo
      bind = $mainMod, J, togglesplit
      bind = $mainMod, F, fullscreen

      # Move focus
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Move focus with vim keys
      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d

      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to workspace
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through workspaces
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Volume and brightness controls
      bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
      bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
      bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
      bind = , XF86MonBrightnessUp, exec, brightnessctl set 10%+
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

      # Screenshots
      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
      bind = $mainMod, Print, exec, grim - | wl-copy
    '';
  };

  # Waybar styling
  "${xdg_configHome}/waybar/style.css" = {
    text = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono", monospace;
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(43, 48, 59, 0.9);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #ffffff;
        border-bottom: 3px solid transparent;
      }

      #workspaces button.active {
        background: #64727D;
        border-bottom: 3px solid #ffffff;
      }

      #clock, #battery, #cpu, #memory, #disk, #temperature, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 0 5px;
      }

      #battery.charging {
        color: #ffffff;
        background-color: #26A65B;
      }

      #battery.warning:not(.charging) {
        background-color: #ffbe61;
        color: black;
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';
  };
}
