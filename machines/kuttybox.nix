{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/common/config.nix
      /etc/nixos/common/desktop.nix
    ];

    boot.loader.grub.device = "/dev/sda";

    networking = {
      hostName = "kuttybox";
      wireless.enable = true;
    };

    services.xserver = {
      synaptics.enable = true;

      displayManager.desktopManagerHandlesLidAndPower = false;
    };
}
