{ pkgs, lib, ... }: {
  nixpkgs.config = { # TODO is this good
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    screen

    mosh
    rustup
    crate2nix

    btop
    powertop
    neofetch

    pavucontrol

    obconf
    xcompmgr
    xtrlock-pam
    xsel

    _1password
    _1password-gui

    ripgrep

    inkscape
    gimp

    evince
    gnome.eog
    gnome.cheese

    ruby
    python2
    python3

    cabal2nix
    cabal-install
    nix-prefetch-git

    chatterino2

    signal-desktop

    wmctrl # for xvim
  ];

  programs.firefox.enable = true;
  programs.gh.enable = true;
  programs.go.enable = true;
  programs.irssi.enable = true;
  programs.jq.enable = true;
  programs.man.enable = true;
  programs.mpv.enable = true;
  programs.obs-studio.enable = true;

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
      tabnine-vim # TODO conditional on which system maybe
      rust-vim
      vim-go
      typescript-vim
      vim-nix
    ];
    extraConfig = ''
      syntax on
      set bs=2                " Allow backspacing over everything in insert mode
      set ruler               " Show the cursor position all the time
      set viminfo='20,\"500   " Keep a .viminfo file.
      set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo " lower tab completion prio
      set numberwidth=3
      set nomodeline
      set laststatus=1

      map Q gq " Don't use Ex mode, use Q for formatting

      set tabstop=2 shiftwidth=2 softtabstop=2 smarttab noexpandtab " expandtab

      "autocmd FileType changelog setlocal noet ts=8 sw=8 sts=8
      autocmd BufNewFile,BufRead SCons*     setf scons
      "autocmd FileType go setlocal ts=4 sw=4 sts=4 noet textwidth=72
      "autocmd FileType gitcommit set nosmartindent
      autocmd FileType sh let is_bash = 1 | set syn=sh

      let g:rust_recommended_style = 0

      let g:terraform_fmt_on_save=1

      set autoindent
      "set smartindent

      filetype plugin indent on

      " from vimrc_example.vim
      " When editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

      filetype off
      filetype on

      set undofile                " Save undo's after file closes
      set undodir=$HOME/.vim/undo " where to save undo histories
      set undolevels=1000         " How many undos
      set undoreload=10000        " number of lines to save for undo

      set backupdir=~/.vim-tmp,.,~/tmp,~/.local/tmp
      set directory=~/.vim-tmp,.,~/tmp,~/.local/tmp

      set history=1000

      set textwidth=78

      set t_Co=8
      set bg=light
      set showcmd
      set hlsearch
      set title
      set scrolloff=4

      " smart comment editing
      set formatoptions+=jcroqn

      nnoremap <C-Right> e
      nnoremap <C-Left> b
      inoremap <C-Right> <ESC>lei
      inoremap <C-Left> <ESC>bi
      map <Up> gk
      map <Down> gj

      " display trailing whitespace as blue underlines
      autocmd WinEnter,VimEnter *
      \ highlight TrailingWhitespace cterm=underline gui=underline guifg=darkblue ctermfg=darkblue |
      \ let w:matchTrailing=matchadd('TrailingWhitespace', '\s\+$', -1) |
      \ highlight Tab cterm=underline gui=underline guifg=darkgray ctermfg=darkgray |
      \ let w:matchTab=matchadd('Tab', '\t', -1)

      set nojoinspaces " no double spaces after periods
      set clipboard-=autoselect " don't clobber * with any visual mode selection

      " vim-go stuff mostly

      let g:go_fmt_command = "goimports"

      map <C-n> :cnext<CR>
      map <C-m> :cprevious<CR>
      nnoremap <leader>a :cclose<CR>

      " run :GoBuild or :GoTestCompile based on the go file
      function! s:build_go_files()
        let l:file = expand('%')
        if l:file =~# '^\f\+_test\.go$'
          call go#test#Test(0, 1)
        elseif l:file =~# '^\f\+\.go$'
          call go#cmd#Build(0)
        endif

      endfunction

      autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

      " run :GoRun or :GoTest based on the go file
      function! s:run_go_files()
        let l:file = expand('%')
        if l:file =~# '^\f\+_test\.go$'
          call go#test#Test(0, 0)
        elseif l:file =~# '^\f\+\.go$'
          call go#cmd#Run(0)
        endif
      endfunction

      autocmd FileType go nmap <leader>r :<C-u>call <SID>run_go_files()<CR>

      "let g:go_highlight_types = 1
      "let g:go_highlight_extra_types = 1
      "let g:go_highlight_fields = 1
      "let g:go_highlight_functions = 1
      "let g:go_highlight_function_calls = 1
      "let g:go_highlight_operators = 1

      "let g:go_auto_type_info = 1
      "let g:go_auto_sameids = 1
      "set updatetime=50

      " dont pop up rust docs or whatever
      set completeopt-=preview
    '';
  };

  programs.urxvt = {
    enable = true;
    package = pkgs.rxvt_unicode-with-plugins;
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
