{ writeShellApplication, lib, config, pkgs, nixvim, home-manager, ... }:
{
  programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = {
        ls =
        "ls --color=auto --group-directories-first --human-readable --file-type";
        ll = "exa -laF --group-directories-first --git --colour-scale";
        llg = "exa -laF --group-directories-first --git --colour-scale --grid";
        skak = "sudoedit";

        rm = "rm -vI";
        cp = "cp -vi";
        df = "df -h";
        mv = "mv -v";
        diff = "diff --color=auto";
        htop = "htop -d2 -t -u $USER";
        free = "free -h";
        please = "sudo";
        mkdir = "mkdir -v";
        wget = "wget --no-hsts";
        ip = "ip --color=auto";
        open = "handlr open";
        pkill = "pkill -ei";
        zmv = "noglob zmv -W"; 

        yt-dlp-mp3 = "yt-dlp -i -c --extract-audio --audio-format mp3 --audio-quality 0";
      };

      initExtra = ''
        [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}

            #
            # Keys
            #
            # create a zkbd compatible hash;
            # to add other keys to this hash, see: man 5 terminfo

            # vim-like history
            autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search

            WORDCHARS='~!#$$%^&*(){}[]<>?.+;-'
            MOTION_WORDCHARS='~!#$$%^&*(){}[]<>?.+;-/'

            # Bash-like navigation
            autoload -U select-word-style
            select-word-style bash

            # Finally, make sure the terminal is in application mode, when zle is
            # active. Only then are the values from $terminfo valid.
            if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
              autoload -Uz add-zle-hook-widget
              function zle_application_mode_start { echoti smkx }
              function zle_application_mode_stop { echoti rmkx }
              add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
              add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
            fi

            # bindkey -v

            typeset -g -A key

            key[Home]="''${terminfo[khome]}"
            key[End]="''${terminfo[kend]}"
            key[Insert]="''${terminfo[kich1]}"
            key[Backspace]="''${terminfo[kbs]}"
            key[Delete]="''${terminfo[kdch1]}"
            key[Up]="''${terminfo[kcuu1]}"
            key[Down]="''${terminfo[kcud1]}"
            key[Left]="''${terminfo[kcub1]}"
            key[Right]="''${terminfo[kcuf1]}"
            key[PageUp]="''${terminfo[kpp]}"
            key[PageDown]="''${terminfo[knp]}"
            key[Shift-Tab]="''${terminfo[kcbt]}"
            key[Control-Left]="''${terminfo[kLFT5]}"
            key[Control-Right]="''${terminfo[kRIT5]}"

            # setup key accordingly
            [[ -n "''${key[Home]}"          ]] && bindkey -- "''${key[Home]}"          beginning-of-line
            [[ -n "''${key[End]}"           ]] && bindkey -- "''${key[End]}"           end-of-line
            [[ -n "''${key[Insert]}"        ]] && bindkey -- "''${key[Insert]}"        overwrite-mode
            [[ -n "''${key[Backspace]}"     ]] && bindkey -- "''${key[Backspace]}"     backward-delete-char
            [[ -n "''${key[Delete]}"        ]] && bindkey -- "''${key[Delete]}"        delete-char
            [[ -n "''${key[Up]}"            ]] && bindkey -- "''${key[Up]}"            up-line-or-beginning-search
            [[ -n "''${key[Down]}"          ]] && bindkey -- "''${key[Down]}"          down-line-or-beginning-search
            [[ -n "''${key[Left]}"          ]] && bindkey -- "''${key[Left]}"          backward-char
            [[ -n "''${key[Right]}"         ]] && bindkey -- "''${key[Right]}"         forward-char
            [[ -n "''${key[PageUp]}"        ]] && bindkey -- "''${key[PageUp]}"        beginning-of-buffer-or-history
            [[ -n "''${key[PageDown]}"      ]] && bindkey -- "''${key[PageDown]}"      end-of-buffer-or-history
            [[ -n "''${key[Shift-Tab]}"     ]] && bindkey -- "''${key[Shift-Tab]}"     reverse-menu-complete
            [[ -n "''${key[Control-Left]}"  ]] && bindkey -- "''${key[Control-Left]}"  backward-word
            [[ -n "''${key[Control-Right]}" ]] && bindkey -- "''${key[Control-Right]}" forward-word

            bindkey '^H' backward-kill-word
            bindkey "\e[H" beginning-of-line
            bindkey "\e[F" end-of-line
      '';

      zplug = {
         enable = true;
         plugins = [
          { name = "agkozak/zsh-z"; } # Simple plugin installation
          { name = "marzocchi/zsh-notify"; }
          { name = "romkatv/powerlevel10k"; tags = [ as:theme ]; }
         ];
      };
  };
}
