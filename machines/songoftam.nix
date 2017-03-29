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
    boot.initrd.luks.devices = [
       {
         name = "root";
         device = "/dev/sda3";
         preLVM = true;
       }
    ];

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
      ledger
      skype
      steam
      vagrant
    ];

    hardware.bumblebee.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;

    # Enable udev rules for Android devices
    services.udev.packages = with pkgs; [ android-udev-rules ];

    # Docker
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "nafai" ];

    # Virtualbox
    virtualisation.virtualbox.host.enable = true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "nafai" ];

    # Xserver
    services.xserver = {
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
    };
}
