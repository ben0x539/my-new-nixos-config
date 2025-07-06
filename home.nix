{ pkgs, lib, ... }: {
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    nixos-option

    screen
    mosh

    btop
    powertop
    neofetch

    pavucontrol

    obconf
    xcompmgr
    xsel
    feh

    firefox

    _1password
    _1password-gui

    ripgrep

    inkscape
    gimp

    audacious

    evince
    eog
    cheese
    gnome-tweaks

    gcc
    gdb

    ghc

    rustup
    crate2nix
    cargo-edit

    ruby
    #python2
    python3

    cabal2nix
    cabal-install
    nix-prefetch-git
    gitg

    chatterino2
    signal-desktop
    discord

    maim
    xclip

    unzip
    zip
    rar
    atool

    nodejs
    yarn

    man-pages

    wmctrl # for xvim

    #logseq

    scrypt

    texlive.combined.scheme-full

    prismlauncher

    yt-dlp

    ffmpeg-full # need full for x11grab

    gopls

    xorg.xwininfo

    calibre

    graphviz
  ];

  programs.chromium.enable = true;
  programs.go.enable = true;
  programs.irssi.enable = true;
  programs.jq.enable = true;
  programs.man.enable = true;
  programs.mpv.enable = true;
  programs.obs-studio.enable = true;
  programs.alacritty.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      version = 1;
    };
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      set editing-mode vi

      set keymap vi-command

      "\e[1;5C": forward-word
      "\e[1;5D": backward-word

      "\e[1;C": forward-char
      "\e[1;D": backward-char

      "\e?": reverse-search-history
      "\e/": forward-search-history

      set keymap vi-insert

      "\e[1;5C": forward-word
      "\e[1;5D": backward-word

      "\e[1;C": forward-char
      "\e[1;D": backward-char

      TAB: complete
      set enable-bracketed-paste on
      '';
  };

  programs.mercurial = {
    enable = true;
    userName = "Benjamin Herr";
    userEmail = "git@1d6.org";
  };

  programs.git = {
    enable = true;
    userName = "Benjamin Herr";
    userEmail = "git@1d6.org";
    # todo
    extraConfig = {
      core = {
        whitespace = "trailing-space";
        # dont exit `less` when reaching the end, so `x git diff` works right.
        pager = "less -+F";
      };
      color = {
        ui = "auto";
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      push = {
        default = "current";
      };
      merge = {
        conflictstyle = "diff3";
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
      sendemail = {
        smtpencryption = "tls";
        smtpserver = "hosting.0x539.de";
        smtpserverport = "587";
      };
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; lib.mkOverride 99 [
      # override to not get vim-sensible.
      #tabnine-vim # broken/YouCompleteMe # TODO conditional on which system maybe
      rust-vim
      vim-go
      typescript-vim
      vim-nix
      haskell-vim

      vim-lsp

      # coc-nvim
      # coc-rust-analyzer
      # coc-java
    ];
    extraConfig = builtins.readFile ./home/vimrc;
  };

  programs.urxvt = {
    enable = true;
    package = pkgs.rxvt-unicode;
    keybindings = {
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };
    scroll.bar.enable = false;
    extraConfig = {
      # disable ctrl+shift
      # https://wiki.archlinux.org/index.php/rxvt-unicode
      # https://wilmer.gaa.st/blog/archives/36-rxvt-unicode-and-ISO-14755-mode.html
      iso14755 = false;
      iso14755_52 = false;

      # dont put stuff in the secondary screen in the scrollback buffer
      secondaryScreen = "1";
      secondaryScroll = "0";
      # unsure if that does anything?
      secondaryWheel = "0";

      # clickable urls. mildly weird because it makes selecting stuff
      # that looks like a url harder? welp
      #URxvt.perl-ext-common = "default,matcher,font-size";
      #URxvt.url-launcher = "xdg-open";
      #URxvt.matcher.button = "1";
      #URxvt.matcher.rend.0 = "fg0";
      perl-ext-common = "default,font-size";

      # explicitly set font so font-size doesnt complain
      # font = "fixed";
      # figure out if we can use non-bitmap fonts for bigger-than-default sizes

      # https://github.com/majutsushi/urxvt-font-size
      # defaults dont seem to work
      "keysym.C-KP_Add"      = "font-size:increase";
      "keysym.C-KP_Subtract" = "font-size:decrease";
      #keysym.C-plus   = "font-size:increase";
      #keysym.C-Down   = "font-size:decrease";
      #keysym.C-S-Up   = "font-size:incglobal";
      #keysym.C-S-Down = "font-size:decglobal";
      #keysym.C-equal  = "font-size:reset";
      #keysym.C-slash  = "font-size:show";

      # doesnt seem to work
      borderless = "True";

      saveLines = "10000";

      depth = "32";
      foreground = "gray";
      background = "[90]black";
      fading = 20;
      fadeColor = "black";
      color0 = " #2E3436";
      color1 = " #CC0000";
      color2 = " #4E9A06";
      color3 = " #C4A000";
      color4 = " #3465A4";
      color5 = " #75507B";
      color6 = " #36B8BA";
      color7 = " #D3D7CF";
      color8 = " #555753";
      color9 = " #EF2929";
      color10 = "#8AE234";
      color11 = "#FCE94F";
      color12 = "#729FCF";
      color13 = "#AD7FA8";
      color14 = "#34E2E2";
      color15 = "#EEEEEC";
      scrollBar = "False";
      "keysym.A-a" = "ä";
      "keysym.A-A" = "Ä";
      "keysym.A-o" = "ö";
      "keysym.A-O" = "Ö";
      "keysym.A-u" = "ü";
      "keysym.A-U" = "Ü";
      "keysym.A-s" = "ß";
      "keysym.A-S" = "ẞ";
      "keysym.A-0" = "ಠ";
      "keysym.A-D" = "ᗡ";
      "keysym.A-minus" = "¯";
      "keysym.A-period" = "●";
      "keysym.C-Left" = "\\033[1;5D";
      "keysym.C-Right" = "\\033[1;5C";
      searchable-scrollback = "M-S-s";
      visualBell = true;
    };
  };

  programs.vscode ={
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      rust-lang.rust-analyzer
      ms-python.python
      golang.go
    ];
  };

  services.xscreensaver = {
    enable = true;
    settings = {
      fadeTicks = 0;
      mode = "blank";
    };
  };

  # unported xresources
  #
  # ! xrandr, divide screen res by listed size, in inches
  # Xft.dpi: 96
  # 
  # 
  # ! idk if any of this is good
  # Xft.autohint: 0
  # Xft.lcdfilter:  lcddefault
  # Xft.hintstyle:  hintfull
  # Xft.hinting: 1
  # Xft.antialias: 1
  # Xft.rgba: rgb
  # 
  # xterm*foreground: gray
  # xterm*background: black
  # xterm*saveLines: 8000
}
