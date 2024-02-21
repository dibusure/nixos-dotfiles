{ writeShellApplication, config, lib, nixosConfig, pkgs, ... }:
{

  xdg.configFile."waybar/config".text = lib.generators.toJSON { } {
    layer = "top"; # Waybar at top layer
    position = "bottom"; # Waybar position (top|bottom|left|right)
    height = 30; # Waybar height (to be removed for auto height)
    # "width"= 1280; // Waybar width
    spacing = 4; # Gaps between modules (4px)
    # Choose the order of the modules
    modules-left = ["sway/workspaces" "custom/media"];
    "modules-center"= ["clock"];
    "modules-right"= ["network" "battery" "temperature" "cpu" "pulseaudio" "sway/language" "tray" "custom/notification"];

    "custom/media" = {
        format = "{icon} {}";
        escape = true;
        max-length = 40;
        on-click = "playerctl play-pause";
        smooth-scrolling-threshold = 10; # This value was tested using a trackpad, it should be lowered if using a mouse.
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        restart-interval = 1;
        exec = "$HOME/.config/waybar/mediaplayer.sh 2> /dev/null"; # Script in resources/custom_modules folder
    };

    "custom/notification" = {
      tooltip = false;
      format = "{icon} {}";
      format-icons = {
        notification = " ";
        none = "";
        dnd-notification = " ";
        dnd-none = "";
        inhibited-notification = " ";
        inhibited-none = "";
        dnd-inhibited-notification = " ";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "task-waybar";
      escape = true;
    };

    "sway/language" = {
      format = "{flag}";
    };

    keyboard-state = {
        numlock = true;
        capslock = true;
        format = "{name} {icon}";
        format-icons= {
            locked = "";
            unlocked = "";
        };
    };
    "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
    };
     network = {
        interface = "wlp1s0";
        format = "{essid}";
        format-wif = " {essid}";
        format-ethernet = "{ipaddr}/{cidr} ";
        #"format-disconnected"= ""; //An empty format will hide the module.
        tooltip-format = "{ifname} via {gwaddr} ";
        tooltip-format-wifi = "{essid} ({signalStrength}%) ";
        tooltip-format-ethernet = "{ifname} ";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
    };
    tray= {
        # "icon-size"= 21;
        spacing = 10;
    };
    clock = {
            format = "{:%B %d}";
            format-alt = "{:%H:%M}";
    };

    cpu = {
        format = "{usage}% ";
        tooltip = true;
    };
    memory = {
        format = "{}% ";
    };
    temperature = {
        # "thermal-zone"= 2;
        # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 80;
        # "format-critical"= "{temperatureC}°C {icon}";
         format = "{temperatureC}°C";
    };
     backlight = {
        format = "{percent}% {icon}";
        format-icons = ["" "" "" "" "" "" "" "" ""];
    };
    battery = {
        states= {
            # "good"= 95;
            warning = 30;
            critical = 15;
        };
        format = "{icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
        tooltip = "true";
    };
    "battery#bat2"= {
        bat = "BAT0";
    };
    pulseaudio = {
        # "scroll-step"= 1; // % can be a float
        format= "{icon} {volume}%";
        format-bluetooth= " {volume}%";
        format-bluetooth-muted= " {icon} {format_source}";
        format-source= "{volume}% ";
        format-source-muted= "";
        format-icons= {
            default = ["" "" ""];
        };
        on-click = "pavucontrol";
    };
  };

  xdg.configFile."waybar/style.css".source = pkgs.substituteAll ({
	    src = ./waybar.css;
  });


  systemd.user.services.waybar = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "https://github.com/Alexays/Waybar/wiki/";
      PartOf = [ "sway-session.target" ];
    };

    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      # ensure sway is already started otherwise workspaces will not work
      ExecStartPre = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "${pkgs.utillinux}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };
}
