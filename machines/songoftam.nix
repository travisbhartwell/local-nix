{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/common/config.nix
      /etc/nixos/common/desktop.nix
    ];

    boot.loader.grub.device = "/dev/sda";
    boot.initrd.luks.devices = [
       {
         name = "root";
         device = "/dev/sda3";
         preLVM = true;
       }
    ];

    hardware.opengl.driSupport32Bit = true;

    networking = {
      hostName = "songoftam";
      # Also allow ssh on port 2500, mpd, and weechat relay
      extraHosts = builtins.readFile "/home/nafai/Projects/local-nix/machines/songoftam-hosts";
      wireless.enable = true;
    };

    environment.systemPackages = with pkgs; [
      ## Hardware Support
      libvdpau

      ## Applications
      ledger
      skype
      steam
    ];

    hardware.pulseaudio.package = pkgs.pulseaudioFull;

    # Enable udev rules for Android devices
    services.udev.packages = with pkgs; [ android-udev-rules ];

    # Virtualbox
    virtualisation.virtualbox.host.enable = true;
    nixpkgs.config.virtualbox.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = [ "nafai" ];

    # Xserver
    services.xserver = {
      vaapiDrivers = with pkgs; [ vaapiIntel vaapiVdpau ];
      videoDrivers = [ "nvidia" ];
      synaptics.enable = true;
    };
}
