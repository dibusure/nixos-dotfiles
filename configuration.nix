{ config, pkgs, lib, inputs, nur, self, rycee, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];


  # ZRAM
  zramSwap.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };


  #cpu freq minimize
  services.tlp = {
    enable = true;
    settings = {
      # Refer to the output of tlp-stat -p to determine the active scaling driver and available governors.
      CPU_SCALING_MIN_FREQ_ON_AC = 1200000;
      CPU_SCALING_MAX_FREQ_ON_AC = 3300000; 
      CPU_SCALING_MIN_FREQ_ON_BAT = 1200000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 2600000;
    };
  };

  boot.plymouth = {
    enable = true;
    themePackages = [ pkgs.adi1090x-plymouth-themes ];
    theme = "dna";
  };

  programs.wshowkeys.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
    
  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];
  programs.fish.enable = true;

  services.logind.extraConfig = "HandleLidSwitch=ignore";
  services.logind.lidSwitch = "ignore";
  services.power-profiles-daemon.enable = false;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.ratbagd.enable = true;

  nixpkgs.overlays = [
    inputs.nur.overlay
    (self: super: {
      discord = super.discord.override { withOpenASAR = true; };
    })
  ];

  environment.variables = {
    EDITOR = "nvim";
    QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
    QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
  };

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware = {
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # luks
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/f4f34458-8f76-4de1-9ef1-17614640135d";
      allowDiscards = true; # Used if primary device is a SSD
      preLVM = true;
    };
  };

  networking.hostName = "canopus"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  };


  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  services.greetd = {
     enable = true;
     settings.default_session.command = "''${pkgs.greetd.greetd}/bin/agreety --cmd ${pkgs.swayfx}/bin/sway";
     restart = true;
  };

  users.users.dibusure = {
    isNormalUser = true;
    extraGroups = [ "wheel" "games" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$liw2iVbBS0qQHWc5ZbvhX/$ip3NBZYc5lltihjWJW8W7km6hyfIq4j26s6wps2B4/.";
  };
  
  users.defaultUserShell = pkgs.fish;

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.pathsToLink = [ "/share/Kvantum" ];

  # to unify dialogs
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    fira-code
    source-code-pro
    envypn-font
    fira
    ibm-plex
    jetbrains-mono
    iosevka
    ubuntu_font_family
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    powerline-fonts
    font-awesome
    winePackages.fonts
    corefonts
    liberation_ttf
    xfontsel
  ];

  xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager 
    fzf
    grc
    mesa
    libpulseaudio
    gcc
    inputs.nix-alien.packages.${system}.default
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];


  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);


  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "mailspring-1.12.0"
  ];


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.gamemode.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  #services.printing.drivers = [ pkgs.pantum-driver ];
  
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true; 
  };

  programs.nix-ld.enable = true;
  system.stateVersion = "23.11"; # Did you read the comment? - A bit
}

