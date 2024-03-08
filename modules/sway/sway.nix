#
# INSPIRED BY https://git.sbruder.de/simon/nixos-config/src/branch/master/users/simon/modules/sway/default.nix
###

{ writeShellApplication, lib, config, pkgs, nixvim, home-manager, ... }:
let
  cfg = config.wayland.windowManager.sway.config;

in
{
  home.file.".config/tofi/config".source = ./tofi;

  imports = [
    ./waybar.nix
    ./swaync.nix
  ];

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
      size = 20;
    };
    iconTheme = {
      package = pkgs.colloid-icon-theme;
      name = "Colloid-dark";
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic-darker";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures = { gtk = true; };
    extraConfig = ''
      blur enable
      layer_effects "waybar" blur enable
      layer_effects "swaync-control-center" blur enable
    '';
    config = rec {
      modifier = "Mod4";
      terminal = "foot"; 
      menu = "${pkgs.tofi}/bin/tofi-drun | xargs swaymsg exec --";

      startup = [
        { command = "autotiling"; }
        { command = "blueman-manager";}
        { command = "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'"; always = true; }
        { command = "nm-applet --indicator";}
        { command = "copyq";}
        { command = "systemctl --user import-environment PATH"; }
        { command = "systemctl --user start sway-session.target"; }
        { command = "exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"; }
        { command = "exec swaync"; }
      ];
      
      defaultWorkspace = "workspace number 1";

 	    input = {
        "type:keyboard" = {
          xkb_layout = "ru,us";
          xkb_options = "grp:caps_toggle";
        };
        "type:touchpad" = {
          click_method = "clickfinger";
          tap = "enabled";
        };
      };

      keybindings = {
        "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
        "${cfg.modifier}+Shift+q" = "kill";
        "${cfg.modifier}+d" = "exec ${cfg.menu}";
        "${cfg.modifier}+Shift+r" = "reload";
        "${cfg.modifier}+Shift+c" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "Print" = "exec slurp | grim -g - - | wl-copy -t image/png";
        "${cfg.modifier}+Escape" = "exec wlogout";
        "${cfg.modifier}+Shift+v" = "exec foot pulsemixer";

        "${cfg.modifier}+Shift+n" = "exec swaync-client -t -sw";

        "${cfg.modifier}+Left" = "focus left";
        "${cfg.modifier}+Down" = "focus down";
        "${cfg.modifier}+Up" = "focus up";
        "${cfg.modifier}+Right" = "focus right";

        # Moving
        "${cfg.modifier}+Shift+${cfg.left}" = "move left";
        "${cfg.modifier}+Shift+${cfg.down}" = "move down";
        "${cfg.modifier}+Shift+${cfg.up}" = "move up";
        "${cfg.modifier}+Shift+${cfg.right}" = "move right";

        "${cfg.modifier}+Shift+Left" = "move left";
        "${cfg.modifier}+Shift+Down" = "move down";
        "${cfg.modifier}+Shift+Up" = "move up";
        "${cfg.modifier}+Shift+Right" = "move right";

        # Workspaces
        "${cfg.modifier}+1" = "workspace number 1";
        "${cfg.modifier}+2" = "workspace number 2";
        "${cfg.modifier}+3" = "workspace number 3";
        "${cfg.modifier}+4" = "workspace number 4";
        "${cfg.modifier}+5" = "workspace number 5";
        "${cfg.modifier}+6" = "workspace number 6";
        "${cfg.modifier}+7" = "workspace number 7";
        "${cfg.modifier}+8" = "workspace number 8";
        "${cfg.modifier}+9" = "workspace number 9";
        "${cfg.modifier}+0" = "workspace number 10";

        "${cfg.modifier}+Shift+1" = "move container to workspace number 1";
        "${cfg.modifier}+Shift+2" = "move container to workspace number 2";
        "${cfg.modifier}+Shift+3" = "move container to workspace number 3";
        "${cfg.modifier}+Shift+4" = "move container to workspace number 4";
        "${cfg.modifier}+Shift+5" = "move container to workspace number 5";
        "${cfg.modifier}+Shift+6" = "move container to workspace number 6";
        "${cfg.modifier}+Shift+7" = "move container to workspace number 7";
        "${cfg.modifier}+Shift+8" = "move container to workspace number 8";
        "${cfg.modifier}+Shift+9" = "move container to workspace number 9";
        "${cfg.modifier}+Shift+0" = "move container to workspace number 10";

        # Moving workspaces between outputs
        "${cfg.modifier}+Control+${cfg.left}" = "move workspace to output left";
        "${cfg.modifier}+Control+${cfg.down}" = "move workspace to output down";
        "${cfg.modifier}+Control+${cfg.up}" = "move workspace to output up";
        "${cfg.modifier}+Control+${cfg.right}" = "move workspace to output right";

        "${cfg.modifier}+Control+Left" = "move workspace to output left";
        "${cfg.modifier}+Control+Down" = "move workspace to output down";
        "${cfg.modifier}+Control+Up" = "move workspace to output up";
        "${cfg.modifier}+Control+Right" = "move workspace to output right";

        # Splits
        "${cfg.modifier}+b" = "splith";
        "${cfg.modifier}+v" = "splitv";

        # Layouts
        "${cfg.modifier}+s" = "layout stacking";
        "${cfg.modifier}+t" = "layout tabbed";
        "${cfg.modifier}+e" = "layout toggle split";
        "${cfg.modifier}+f" = "fullscreen toggle";

        "${cfg.modifier}+a" = "focus parent";

        "${cfg.modifier}+Shift+space" = "floating toggle";
        "${cfg.modifier}+space" = "focus mode_toggle";

        # Scratchpad
        "${cfg.modifier}+Shift+minus" = "move scratchpad";
        "${cfg.modifier}+minus" = "scratchpad show";

        # Resize mode
        "${cfg.modifier}+r" = "mode resize";


        # Media keys
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulsemixer}/bin/pulsemixer --change-volume +5";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulsemixer}/bin/pulsemixer --change-volume -5";

         	
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl prev";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";

      };

      bindkeysToCode = true;

      output = {
        eDP-1 = {
          bg = "`find '/home/dibusure/pc/walls' -type f | shuf -n 1` fill";
        };
      };

      gaps = {
        inner = 10;
        smartGaps = true;
      };


      bars = [ ]; # DAMN IT STRING SUKA


      window.border = 1;
      window.titlebar = false;
        floating = {
	        titlebar = true;
	        border = 1;
      		};
	
	      colors = {
	        focused = rec { border = "#ebcb8b"; background = "#ebcb8b"; text = "#000000"; indicator = "#000000"; childBorder = "#ebcb8b"; };
	        focusedInactive = rec { border = "#000000"; background = "#000000"; text = "#000000"; indicator = "#000000"; childBorder = "#000000"; };
	        unfocused = rec { border = "#000000"; background = "#000000"; text = "#000000"; indicator = "#000000"; childBorder = "#000000"; };
	        urgent = rec { border = "#000000"; background = "#000000"; text = "#000000"; indicator = "#000000"; childBorder = "#000000"; };
	      };
    };
    extraSessionCommands = ''
      # cursor fix
      export WLR_NO_HARDWARE_CURSORS=1
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME=qt5ct
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  programs.wlogout = {
    enable = true;
    style = ''
window {
	background-color: #2e344060;
}
button {
  color: #eceff4;
	background-color: #3b4252;
	border-style: solid;
	border-width: 2px;
	background-repeat: no-repeat;
	background-position: center;
	background-size: 25%;
}

button:focus, button:active, button:hover {
	background-color: #81a1c1;
	outline-style: none;
}
    '';
  };
  
  services.mako = {
    enable = false;
    package = pkgs.mako;
    backgroundColor = "#4c566a";
    borderColor = "#eceff4";
    borderRadius = 2;
    borderSize = 1;
    icons = false;
    textColor = "#eceff4";
    extraConfig = ''
layer=overlay
font=Iosevka 12
[urgency=high]
background-color=#bf616a

[mode=do-not-disturb]
invisible=1
    '';
  };
  
  systemd.user.targets.sway-session = {
	  Unit = {
      Description = "sway compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };


  programs.swaylock = {
    enable = true;
    settings = {
      color = "#eceff4";
      font-size = 20;
      font = "Iosevka";
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "#a3be8c";
      show-failed-attempts = true;
    };
  };

  services.swayidle.enable = true;

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Iosevka:size=14";
      };
      cursor = {
        color = "2e3440 d8dee9";
      };
      colors = {
        foreground = "d8dee9";
        background = "2e3440";
        alpha = "0.9";

        regular0 = "3b4252";
        regular1 = "bf616a";
        regular2 = "a3be8c";
        regular3 = "ebcb8b";
        regular4 = "81a1c1";
        regular5 = "b48ead";
        regular6 = "88c0d0";
        regular7 = "e5e9f0";

        bright0 = "4c566a";
        bright1 = "bf616a";
        bright2 = "a3be8c";
        bright3 = "ebcb8b";
        bright4 = "81a1c1";
        bright5 = "b48ead";
        bright6 = "8fbcbb";
        bright7 = "eceff4";

        dim0 = "373e4d";
        dim1 = "94545d";
        dim2 = "809575";
        dim3 = "b29e75";
        dim4 = "68809a";
        dim5 = "8c738c";
        dim6 = "6d96a5";
        dim7 = "aeb3bb";
      };
    };
  };



  home.packages = with pkgs; [
    brightnessctl # control screen brightness
    sway-contrib.grimshot # screenshots
    wl-clipboard # cli tool to manage wayland clipboard
    tofi # rofi is a piece of shit
    dconf
    pulsemixer # puseaudio mixer
    wf-recorder # simple recorder
    grim slurp
    swaynotificationcenter
    autotiling
    pavucontrol
    networkmanagerapplet
    copyq
  ];

}
