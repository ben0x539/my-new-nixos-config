{ config, lib, pkgs, modulesPath, ... }:


{
  # nvme0n1p1: encrypted zfs pool
  # nvme0n1p1: unencrypted 
  # idk why these weren't autogenerated the second time.
  boot.initrd.availableKernelModules = [ "usb_storage" "sd_mod" ];

  # need >=5.14 or something for wifi
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  fileSystems."/" = {
    encrypted = {
      enable = true;
      blkDev = "/dev/disk/by-uuid/ea283f6d-cef5-4c47-b2c5-8f4dec4d6a3a";
      label = "crypted";
    };
    label = "zfw";
  };

  # the double // somehow tricks it into not waiting for this
  # device to come up too early (before decrypt? idr. i guess
  # most people don't use encrypted zfs swap, which, fair.)
  # ((https://nixos.wiki/wiki/ZFS specifically advises against
  # using a zvol as a swap device.))
  # (((but this will never come up, right?)))
  # default is 100, so this is the nicest possible override.
  swapDevices = lib.mkOverride 99 [ { device = "//dev/zvol/zfw/swap"; } ];

  # probably need these to boot.
  systemd.services.zfs-mount.requiredBy = [ "local-fs.target" ];
  boot.supportedFilesystems = [ "zfs" ];
  # https://nixos.wiki/wiki/ZFS
  boot.kernelParams = [ "nohibernate" ];

  # the zfs setup PROBABLY went something like this but
  # i didn't record it, this is based on notes from
  # a few years ago. cryptsetup luksOpen etc on nvme0n1p1.
  #
  # what's missing here is preventing both zfs and nixos
  # trying to mount /home and /home/$user via mountpoint=legacy
  # i think /home/$user defaults to /$user actually which is bad,
  # idk if my notes are wrong on that.
  #
  # blockdevice=/dev/mapper/crypted
  # pool=zfw
  # user=vh
  # root=nixos
  # swapsize=16G
  #
  # zpool create -o ashift=12 \
  #   -o altroot=/mnt \
  #   -O mountpoint=none \
  #   -O atime=off \
  #   -O compression=on \
  #   $pool $blockdevice
  # zfs create -V $swapsize -b $(getconf PAGESIZE) \
  #   -o logbias=throughput -o sync=always \
  #   -o primarycache=metadata \
  #   -o compression=zle \
  #   -o com.sun:auto-snapshot=false $pool/swap
  # zfs create -o mountpoint=/ $pool/$root
  # zfs create -o setuid=off $pool/$root/home
  # zfs create $pool/$root/$user
  #
  # mkswap /dev/zvol/$pool/$swap
  # swapon /dev/zvol/$pool/$swap
  #
  # ...
  #
  # swapoff -a
  # zpool export $pool
}
