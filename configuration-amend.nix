{ config, pkgs, ... }:

{
  imports = [
    # amend hardware scan
    ./hardware-configuration-amend.nix
  ];

  networking.hostName = "vie";

  time.timeZone = "America/Los_Angeles";

  networking.networkmanager.enable = true;
  networking.dhcpcd.enable = false; # since my 2022-01-05 build, dhcpcd breaks networkmanager's dhcp stuff? https://github.com/NixOS/nixpkgs/issues/126498
  networking.hostId = "2e94b734";
  programs.nm-applet.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    windowManager = {
      openbox.enable = true;
    };

    autoRepeatDelay = 150;
    autoRepeatInterval = 25;

    # dpi = 72; ?

    xkb.options = "eurosign:e, caps:swapescape";
  };
  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.displayManager = {
    defaultSession = "none+openbox";
  };
  #fonts.fontconfig.dpi = 96; ?

  fonts.packages = with pkgs; [
    corefonts
    terminus_font
    dejavu_fonts
    vistafonts
    fira-code
    inconsolata
    source-code-pro
    xorg.fontxfree86type1
    #google-fonts
  ];

  services.libinput = {
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

  users.users.minecraftserver = {
    isNormalUser = true;
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
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  nix = {
    settings.sandbox = true;
    settings.max-jobs = 4;
  };

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

  services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  programs.ssh.startAgent = true;
  programs.light.enable = true; # used in openbox rc.xml

  # mostly copied without thinking too hard
  programs.adb.enable = true; # this has a daemon i guess # 'android_sdk.accept_license = true;'

  programs.dconf.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
    };
    libvirtd.enable = true;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
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

  boot.kernelParams = [ "mem_sleep_default=deep" ];
  # i basically never use blutooth stuff but it uses hella battery
  boot.blacklistedKernelModules = [ "bluetooth" "btusb" ];

  # 3.5mm audio jack trrs microphone thing
  boot.extraModprobeConfig = "options snd-hda-intel model=dell-headset-multi";
  # TODO figure out the suspend situation
  # we wake up super fast so it's probably not the good suspend
  # but also hibernate is not really an option

  # idk
  # blueman.enable = true;

  # idk how to get rid of this
  # i think it's via xtrlock
  nixpkgs.config = {
    allowUnfree = true;

    permittedInsecurePackages = [
      "python-2.7.18.8"
      "electron-25.9.0" # ???
    ];

    firefox.speechSynthesisSupport = true;
  };

  networking.firewall.enable = false;
}

