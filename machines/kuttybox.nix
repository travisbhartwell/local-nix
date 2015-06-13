{ config, pkgs, ... }:

{
  imports =
    [
      ../common/config.nix
    ];

    boot.loader.grub.device = "/dev/sda";

    networking = {
      hostName = "kuttybox";
      wireless.enable = true;
    };

    services.xserver.synaptics.enable = true;
}
