{ config, pkgs, nixvim, ... }:
{

  imports = [
    ./modules/sway/sway.nix
    ./modules/zsh/zsh.nix
  ];

  home.stateVersion = "23.11";
  home.username = "dibusure";
  home.homeDirectory = "/home/dibusure";
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Ice";
    gtk.enable = true;
  };

  home.packages = with pkgs; [
    # programming
    python311 go gnumake clang cmake nodejs # compilers

    # gui misc
    mpv imv # nemo is a file manager, mpv is for videos, imv is for photos
    pavucontrol # pavucontrol is a mixer for pulseaudio
    discord telegram-desktop floorp # two messengers and browser
    libsForQt5.dolphin # file manager
    libsForQt5.okular # pdf viewer

    # cli misc
    pfetch screenfetch neofetch # better neofetchs and neofetch
    tmux screen # two amazing multiplexers 
    fanctl # fanconrol
    unzip unrar # some useless stuff
  ];


  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    desktop = "$HOME/pc/dk";
    documents = "$HOME/pc/docs";
    download = "$HOME/pc/dl";
    music = "$HOME/pc/au";
    pictures = "$HOME/pc/pics";
    videos = "$HOME/pc/vids";
  };
  xdg.systemDirs = {
    data = [ "$HOME/.local/share" ];
    config = [ "$HOME/.config" ];
  };


  programs.ripgrep.enable = true;

  programs.git = {
    enable = true;
    userName = "dibusure";
    userEmail = "dibusure@cock.li";
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      type = "cat-file -t";
      dump = "cat-file -p";
    };
  };
  


  programs.mpv = {
    enable = true;
    #scripts = pkgs.mpvScripts.mpris;
    bindings = {
      n = "playlist-next";
      p = "playlist-prev";
    };
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    changeDirWidgetCommand ="fd --type d";
    defaultOptions = [
      "--preview-window=border-none"
      "--color=fg:#d4d4d4,hl:#dcdcaa"
      "--color=fg+:#f8f8ff,bg+:#2f2f3a,hl+:#ff761a"
      "--color=info:#bfdaff,prompt:#ff5fff,pointer:#cbccc6"
      "--color=marker:#ff3600,spinner:#bfdaff,header:#635196"
      "--no-bold"
      "--prompt '> '"
      "--pointer '>'"
      "--marker '>'"
      "--info=inline"
      "--reverse"
      "-m"
      "--bind \"tab:down\""
      "--bind \"btab:toggle+down\""
      "--cycle"
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.go = {
    enable = true;
    goPath = "$XDG_DATA_HOME/.go";
    goBin = "$XDG_DATA_HOME/.go/bin";
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  services.wlsunset = {
    enable = true;
    latitude = "55.4";
    longitude = "39.0";
    temperature.day = 5500;
    temperature.night = 4000;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;
}
