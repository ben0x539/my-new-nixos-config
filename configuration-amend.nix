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

    # dpi = 72; ?
  };
  #fonts.fontconfig.dpi = 96; ?

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
      "adbusers" # i need this for adb
      #"networkmanager" # i may not need this?
    ];
    uid = 1000;
  };

  # in case we're messing with io_uring again
  security.pam.loginLimits = [
    {
      domain = "vh";
      type = "-";
      item = "memlock";
      value = 128 * 1024;

    }
  ];

  environment.systemPackages = with pkgs; [
    firefox
    tint2 # to see the nm-applet
    rxvt-unicode

    psmisc
    findutils
    lsof
    file
    rsync
    vim_configurable
    exfat
    pmount # todo setuid

    git

    # TODO: move the below out of system config

    _1password
    _1password-gui

    ripgrep
    rustup

    obconf
    xcompmgr
    ruby
    mosh

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

  # mostly copied without thinking too hard
  programs.adb.enable = true; # this has a daemon i guess # 'android_sdk.accept_license = true;'

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
    };
    libvirtd.enable = true;
  };

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  security.wrappers = {
    pmount = {
      source = "${pkgs.pmount.out}/bin/pmount";
      owner = "root";
      group = "root";
      setuid = true;
    };
    pumount = {
      source = "${pkgs.pmount.out}/bin/pumount";
      owner = "root";
      group = "root";
      setuid = true;
    };
  };

  # don't suspend on lid close, don't shutdown on power key
  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=suspend
    '';
  };
  # TODO figure out the suspend situation
  # we wake up super fast so it's probably not the good suspend
  # but also hibernate is not really an option

  # idk
  # blueman.enable = true;
}

