{ config, pkgs, ... }:

{
  imports =
    [
      ./common/config.nix
    ];

    boot.loader.grub.device = "/dev/sdb";

    networking = {
      hostName = "kuttybox";
      wireless.enable = true;
    }

    services.xserver.synaptics.enable = true;
}
