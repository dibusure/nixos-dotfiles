{ config, pkgs, nixvim, ... }:
{

  imports = [
    ./modules/sway/sway.nix
  ];


  home.stateVersion = "23.11";
  home.username = "dibusure";
  home.homeDirectory = "/home/dibusure";

  home.packages = with pkgs; [
    # programming
    zeal # docs viewer
    python311 go gnumake clang cmake nodejs # compilers
    
    #games
    lutris

    (writeShellScriptBin "steam"
      ''
        SDL_VIDEODRIVER=x11 ${pkgs.steam}/bin/steam
      ''
    )
    prismlauncher

    # gui misc
    audacious audacious-plugins # music player
    strawberry # another player
    dropbox-cli yandex-disk # cloud services
    keepassxc # password manager
    leafpad # notepad
    tigervnc # for viewing vnc
    gnome.file-roller # archive manager
    gnome.gnome-calculator # pretty calculator
    gnome.pomodoro # pomodoro timer
    cinnamon.nemo mpv imv # nemo is a file manager, mpv is for videos, imv is for photos
    gimp pavucontrol # gimp is a photoeditor, pavucontrol is a mixer for pulseaudio
    qbittorrent # very powerful torrent client
    discord telegram-desktop floorp # two messengers and browser
    chromium zathura okular # second browser and books readers
    tor-browser-bundle-bin # very needed browser
    obsidian # knowledge base / notes
    obs-studio # for recording audio and video
    libreoffice-fresh onlyoffice-bin # office kits
    winetricks wineWowPackages.stable #wine idk :)
    kitty # second terminal (for streaming in discord)
    gnome.gnome-clocks # gnome clocks
    anki # for languages
    element-desktop # matrix client
    piper # for logitech mice
    vscode # for coding
    gparted # disk partitioner
    
    # cli misc
    python311Packages.pygobject3 python311Packages.gst-python
    ranger # cli file manager
    ffmpeg-full # ffmpeg
    pulsemixer # pulseaudio mixer
    wget comma fzf nix-zsh-completions # comma is for nix apps that not installed, fzf -- fuzzy finder
    killall jq figlet # jq is like sed for JSON data, figlet generates text banners
    xdg-user-dirs xdg-utils # for xdg
    openvpn # just openvpn
    nmap playerctl # nmap is for network scanning, playerctl for controlling playback
    bluez # for bluetooth
    pandoc htop # pandoc is for text files, htop is better top
    lm_sensors # for watching the temperature
    ncdu # nicer du
    libnotify yt-dlp brightnessctl # libnotify to send notifies, yt-dlp to download from youtube, brightnessctl to manage brightness
    steam-run # powerful tool for applications
    #pantum-driver # drivers for printer
    btop powertop # better tops
    pfetch screenfetch neofetch # better neofetchs and neofetch
    tmux screen # two amazing multiplexers 
    ecryptfs cryfs # for encrypting folders 
    gcalcli # google calendar cli
    fanctl # fanconrol
    imagemagick # for cli editing
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
  
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      { name = "hydro"; src = pkgs.fishPlugins.hydro; }
    ];
  };

  programs.mpv = {
    enable = true;
    #scripts = pkgs.mpvScripts.mpris;
    bindings = {
      n = "playlist-next";
      p = "playlist-prev";
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      font = "Fixed 11";
      default-bg = "#1e1e1e";
      completion-bg = "#1e1e1e";
      completion-group-bg = "#1e1e1e";
      completion-highlight-bg = "#569cd6";
      completion-highlight-fg = "#f8f8ff";
      index-active-bg = "#569cd6";
      index-active-fg = "#36363A";
      index-bg = "#36363A";
      inputbar-bg = "#1e1e1e";
      inputbar-fg = "#569cd6";
      statusbar-bg = "#1e1e1e";
      recolor-darkcolor = "#f8f8ff";
      recolor-lightcolor = "#1e1e1e";
      guioptions = "";
      selection-clipboard = "clipboard";
      highlight-transparency = "0.40";
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

  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      style = "plain";
      pager = "never";
    };
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

  programs.neovim = {
    enable = true;
    withPython3 = true;
    coc.enable = true;
    plugins = with pkgs.vimPlugins; [
      semshi #python highlight
      nord-nvim # nord theme
      lightline-vim
    ];  

    #extraPackages = with pkgs; [
      # Language server packages (executables)
    #];

    extraConfig = ''
      set ignorecase
      set smartcase
      set signcolumn
      set background=dark
      set clipboard=unnamedplus
      set completeopt=noinsert,menuone,noselect
      set cursorline
      set hidden
      set inccommand=split
      set mouse=a
      set number
      set splitbelow splitright
      set title
      set ttimeoutlen=0
      set wildmenu
      set laststatus=2

      tnoremap <Esc> <C-\><C-n>


      " Theme
      syntax enable
      " for vim 7
      set t_Co=256

      " for vim 8
      if (has("termguicolors"))
        set termguicolors
      endif

      colorscheme nord 

      " Tabs size
      set expandtab
      set shiftwidth=2
      set tabstop=2
      filetype plugin indent on

      let g:lightline = {'colorscheme': 'nord'}

      " open fucking nerdtree
      inoremap jk <ESC>
    '';
  };

  services.wlsunset = {
    enable = true;
    latitude = "55.4";
    longitude = "39.0";
    temperature.day = 5500;
    temperature.night = 4000;
  };


  programs.waybar = {
    enable = true;
    #systemd.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;
}
