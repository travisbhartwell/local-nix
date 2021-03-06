{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/common/config.nix
      /etc/nixos/common/desktop.nix
    ];

    boot.kernelModules = [ "tp_smapi" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];

    boot.loader.grub.device = "/dev/sda";
    boot.initrd.luks.devices = {
      root = {
         device = "/dev/sda3";
         preLVM = true;
      };
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    hardware.bluetooth.enable = true;

    networking = {
      hostName = "songoftam";
      extraHosts = builtins.readFile "/home/nafai/Projects/local-nix/machines/songoftam-hosts";
      wireless.enable = true;
    };

    environment.systemPackages = with pkgs; [
      ## Applications
      keybase-gui
      ledger
      rclone
      rclone-browser
      skype
      steam
      vagrant
    ];

    hardware.bumblebee.enable = true;
    hardware.bumblebee.connectDisplay = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;

    # Enable udev rules for Android devices
    services.udev.packages = with pkgs; [ android-udev-rules ];

    # Keybase
    services.kbfs.enable = true;

    # Docker
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "nafai" ];

    # Virtualbox
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "nafai" ];

    # Xserver
    services.xserver = {
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };

      videoDrivers = [ "intel" "vesa" ];
    };

    # Set up backup job
    systemd.services.home-backup = {
      enable = true;
      description = "Backup my home directory";
      startAt = "*-*-* 01:00:00";
      path = with pkgs; [ rsync utillinux ];
      script = ''
        mountpoint -q /run/media/nafai/Toshiba3TB && rsync -av --delete /home/nafai/ /run/media/nafai/Toshiba3TB/Backup/songoftam/home/nafai/
      '';
    };
}
