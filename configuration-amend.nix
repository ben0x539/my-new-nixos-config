{ config, pkgs, ... }:

{
  imports = [
    # amend hardware scan
    ./hardware-configuration-amend.nix
  ];

  time.timeZone = "America/Los_Angeles";

  networking.networkmanager.enable = true;
  networking.hostId = "2e94b734";
  programs.nm-applet.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    # Enable the GNOME Desktop Environment.
    #services.xserver.displayManager.gdm.enable = true;
    #services.xserver.desktopManager.gnome.enable = true;
    displayManager.defaultSession = "none+openbox";
    windowManager = {
      openbox.enable = true;
    };

    autoRepeatDelay = 150;
    autoRepeatInterval = 25;

    xkbOptions = "eurosign:e";
  };

  sound.enable = true;

  services.xserver.libinput = {
    enable = true;

    touchpad = {
      naturalScrolling = true;
      tappingDragLock = false;
      additionalOptions = ''
        Option "TappingButtonMap" "lmr"
      '';
    };
  };

  users.users.vh = {
    isNormalUser = true;
    createHome = false; # so zfs can mount i guess
    extraGroups = [
      "wheel"  # Enable ‘sudo’ for the user.
      "video"  # Backlight control.
    ];
    uid = 1000;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    tint2
    rxvt-unicode

    psmisc
    findutils
    lsof
    file
    screen
    rsync
    vim_configurable
    exfat
    pmount # todo setuid

    _1password
    _1password-gui

    ripgrep
    rustup 

    obconf
    xcompmgr
    ruby
    mosh
    git

    wmctrl # for xvim
  ];

  programs.vim.defaultEditor = true;

  nix = {
    useSandbox = true;
    maxJobs = 4;
  };
  nixpkgs.config.allowUnfree = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
  };

  powerManagement.powertop.enable = true;
  programs.ssh.startAgent = true;
  programs.light.enable = true; # used in openbox rc.xml
}

